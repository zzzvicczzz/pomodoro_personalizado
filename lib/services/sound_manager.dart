import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pomodoro_personalizado/domain/models/app_settings_model.dart';

/// Eventos conocidos en los que la app requiere reproducir sonidos.
enum SoundEvent { focusStart, focusEnd, breakStart, breakEnd }

/// Tipos de origen soportados por el administrador de sonidos.
enum SoundSourceType { asset, file, network }

/// Representa una selección de audio configurable desde settings.
class SoundSelection {
  const SoundSelection._(
    this.sourceType,
    this.reference, {
    this.package,
    this.loop = false,
  });

  const SoundSelection.asset(
    String assetPath, {
    String? package,
    bool loop = false,
  }) : this._(SoundSourceType.asset, assetPath, package: package, loop: loop);

  const SoundSelection.file(String filePath, {bool loop = false})
    : this._(SoundSourceType.file, filePath, loop: loop);

  const SoundSelection.network(String url, {bool loop = false})
    : this._(SoundSourceType.network, url, loop: loop);

  final SoundSourceType sourceType;
  final String reference;
  final String? package;
  final bool loop;
}

/// Define cómo se resuelve un sonido según la configuración almacenada.
typedef SoundThemeResolver =
    SoundSelection? Function(AppSettingsModel settings, SoundEvent event);

/// Contrato del servicio de reproducción de sonidos.
abstract class ISoundManager {
  Future<void> initialize({
    AppSettingsModel? initialSettings,
    double initialVolume,
    SoundThemeResolver? themeResolver,
  });

  bool get isInitialized;

  double get volume;

  bool get isMuted;

  Future<void> updateSettings(AppSettingsModel settings);

  Future<void> setVolume(double value);

  Future<void> setMuted(bool muted);

  Future<void> playEvent(SoundEvent event, {double? volumeOverride});

  Future<void> playSelection(
    SoundSelection selection, {
    double? volumeOverride,
  });

  Future<void> stop();

  Future<void> dispose();
}

/// Factoría que garantiza un fallback seguro en plataformas no soportadas.
ISoundManager createSoundManager({SoundThemeResolver? themeResolver}) {
  if (kIsWeb) {
    return NoopSoundManager();
  }
  return SoundManager(themeResolver: themeResolver);
}

/// Implementación basada en `just_audio`.
class SoundManager implements ISoundManager {
  SoundManager({AudioPlaybackEngine? engine, SoundThemeResolver? themeResolver})
    : _engine = engine ?? JustAudioPlaybackEngine(),
      _themeResolver = themeResolver ?? _defaultSoundThemeResolver;

  final AudioPlaybackEngine _engine;
  SoundThemeResolver _themeResolver;

  bool _initialized = false;
  bool _muted = false;
  double _volume = 1.0;
  AppSettingsModel? _settings;

  @override
  bool get isInitialized => _initialized;

  @override
  double get volume => _volume;

  @override
  bool get isMuted => _muted;

  @override
  Future<void> initialize({
    AppSettingsModel? initialSettings,
    double initialVolume = 1.0,
    SoundThemeResolver? themeResolver,
  }) async {
    _settings = initialSettings ?? _defaultAppSettings;
    _volume = _clampVolume(initialVolume);
    _themeResolver = themeResolver ?? _themeResolver;
    _initialized = true;
    await _engine.setVolume(_effectiveVolume());
  }

  @override
  Future<void> updateSettings(AppSettingsModel settings) async {
    await _ensureInitialized();
    _settings = settings;
  }

  @override
  Future<void> setVolume(double value) async {
    await _ensureInitialized();
    _volume = _clampVolume(value);
    if (!_muted && _canPlayBySettings) {
      await _engine.setVolume(_volume);
    }
  }

  @override
  Future<void> setMuted(bool muted) async {
    await _ensureInitialized();
    _muted = muted;
    await _engine.setVolume(_effectiveVolume());
  }

  @override
  Future<void> playEvent(SoundEvent event, {double? volumeOverride}) async {
    await _ensureInitialized();
    final selection = _themeResolver(_resolvedSettings, event);
    if (selection == null) return;
    await _playSelection(selection, volumeOverride: volumeOverride);
  }

  @override
  Future<void> playSelection(
    SoundSelection selection, {
    double? volumeOverride,
  }) async {
    await _ensureInitialized();
    await _playSelection(selection, volumeOverride: volumeOverride);
  }

  @override
  Future<void> stop() async {
    await _engine.stop();
  }

  @override
  Future<void> dispose() async {
    await _engine.dispose();
    _initialized = false;
    _settings = null;
  }

  Future<void> _playSelection(
    SoundSelection selection, {
    double? volumeOverride,
  }) async {
    if (!_canPlayBySettings) return;
    final volume = _effectiveVolume(volumeOverride);
    if (volume <= 0) return;
    await _engine.setSource(selection);
    await _engine.setVolume(volume);
    await _engine.play();
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    throw StateError('SoundManager no ha sido inicializado.');
  }

  double _clampVolume(double value) => value.clamp(0.0, 1.0);

  double _effectiveVolume([double? override]) {
    if (_muted || !_canPlayBySettings) {
      return 0;
    }
    return _clampVolume(override ?? _volume);
  }

  bool get _canPlayBySettings => _resolvedSettings.soundEnabled;

  AppSettingsModel get _resolvedSettings => _settings ?? _defaultAppSettings;
}

/// Implementación nula usada como fallback cuando la plataforma no soporta audio.
class NoopSoundManager implements ISoundManager {
  AppSettingsModel _settings = _defaultAppSettings;
  bool _initialized = false;
  bool _muted = false;
  double _volume = 1.0;

  @override
  bool get isInitialized => _initialized;

  @override
  double get volume => _volume;

  @override
  bool get isMuted => _muted;

  @override
  Future<void> initialize({
    AppSettingsModel? initialSettings,
    double initialVolume = 1.0,
    SoundThemeResolver? themeResolver,
  }) async {
    _settings = initialSettings ?? _settings;
    _volume = _clampVolume(initialVolume);
    _initialized = true;
  }

  @override
  Future<void> updateSettings(AppSettingsModel settings) async {
    _settings = settings;
  }

  @override
  Future<void> setVolume(double value) async {
    _volume = _clampVolume(value);
  }

  @override
  Future<void> setMuted(bool muted) async {
    _muted = muted;
  }

  @override
  Future<void> playEvent(SoundEvent event, {double? volumeOverride}) async {}

  @override
  Future<void> playSelection(
    SoundSelection selection, {
    double? volumeOverride,
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {
    _initialized = false;
  }

  double _clampVolume(double value) => value.clamp(0.0, 1.0);
}

/// Contrato mínimo que encapsula el motor de reproducción concreto.
abstract class AudioPlaybackEngine {
  Future<void> setSource(SoundSelection selection);
  Future<void> setVolume(double volume);
  Future<void> play();
  Future<void> stop();
  Future<void> dispose();
}

/// Adaptador que usa `AudioPlayer` de just_audio.
class JustAudioPlaybackEngine implements AudioPlaybackEngine {
  JustAudioPlaybackEngine({AudioPlayer? player})
    : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<void> setSource(SoundSelection selection) async {
    switch (selection.sourceType) {
      case SoundSourceType.asset:
        await _player.setAudioSource(
          AudioSource.asset(selection.reference, package: selection.package),
        );
      case SoundSourceType.file:
        await _player.setAudioSource(
          AudioSource.uri(Uri.file(selection.reference)),
        );
      case SoundSourceType.network:
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(selection.reference)),
        );
    }
    await _player.setLoopMode(selection.loop ? LoopMode.one : LoopMode.off);
  }

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> dispose() => _player.dispose();
}

const AppSettingsModel _defaultAppSettings = AppSettingsModel(
  soundEnabled: true,
  vibrationEnabled: true,
  notificationsEnabled: true,
  theme: 'classic',
  language: 'es',
);

const String _defaultPaletteKey = 'classic';

const Map<String, Map<SoundEvent, SoundSelection>> _soundPalettes = {
  'classic': {
    SoundEvent.focusStart: SoundSelection.asset(
      'assets/audio/classic/focus_start.mp3',
    ),
    SoundEvent.focusEnd: SoundSelection.asset(
      'assets/audio/classic/focus_end.mp3',
    ),
    SoundEvent.breakStart: SoundSelection.asset(
      'assets/audio/classic/break_start.mp3',
    ),
    SoundEvent.breakEnd: SoundSelection.asset(
      'assets/audio/classic/break_end.mp3',
    ),
  },
  'soft': {
    SoundEvent.focusStart: SoundSelection.asset(
      'assets/audio/soft/focus_start.mp3',
    ),
    SoundEvent.focusEnd: SoundSelection.asset(
      'assets/audio/soft/focus_end.mp3',
    ),
    SoundEvent.breakStart: SoundSelection.asset(
      'assets/audio/soft/break_start.mp3',
    ),
    SoundEvent.breakEnd: SoundSelection.asset(
      'assets/audio/soft/break_end.mp3',
    ),
  },
};

SoundSelection _defaultSoundThemeResolver(
  AppSettingsModel settings,
  SoundEvent event,
) {
  final paletteKey = settings.theme.toLowerCase();
  final palette =
      _soundPalettes[paletteKey] ?? _soundPalettes[_defaultPaletteKey]!;
  return palette[event] ?? _soundPalettes[_defaultPaletteKey]![event]!;
}
