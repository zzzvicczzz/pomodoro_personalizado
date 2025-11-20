import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_personalizado/domain/models/app_settings_model.dart';
import 'package:pomodoro_personalizado/services/sound_manager.dart';

void main() {
  group('SoundManager', () {
    late FakeAudioEngine engine;
    late SoundManager manager;

    setUp(() {
      engine = FakeAudioEngine();
      manager = SoundManager(engine: engine);
    });

    test('initialize configures initial state and volume', () async {
      await manager.initialize(initialVolume: 0.5);

      expect(manager.isInitialized, isTrue);
      expect(manager.volume, equals(0.5));
      expect(engine.volumes.single, equals(0.5));
    });

    test('updateSettings disables playback when sound is disabled', () async {
      await manager.initialize(initialSettings: _settings(enabled: true));
      await manager.updateSettings(_settings(enabled: false));

      await manager.playSelection(_selection);

      expect(engine.sources, isEmpty);
    });

    test('setVolume clamps value and updates engine when unmuted', () async {
      await manager.initialize(initialVolume: 0.4);

      await manager.setVolume(2);
      expect(manager.volume, equals(1.0));
      expect(engine.volumes.last, equals(1.0));

      await manager.setVolume(-1);
      expect(manager.volume, equals(0.0));
      expect(engine.volumes.last, equals(0.0));
    });

    test('setVolume does not touch engine when muted', () async {
      await manager.initialize(initialVolume: 0.4);
      await manager.setMuted(true);
      engine.clear();

      await manager.setVolume(0.8);

      expect(manager.volume, equals(0.8));
      expect(engine.volumes, isEmpty);
    });

    test('mute toggles effective volume to zero and back', () async {
      await manager.initialize(initialVolume: 0.7);

      await manager.setMuted(true);
      expect(engine.volumes.last, equals(0.0));

      await manager.setMuted(false);
      expect(engine.volumes.last, equals(0.7));
    });

    test(
      'playSelection sets source, volume and plays respecting override',
      () async {
        await manager.initialize(initialVolume: 0.8);

        await manager.playSelection(_selection, volumeOverride: 0.3);

        expect(engine.sources.single, equals(_selection));
        expect(engine.volumes.last, equals(0.3));
        expect(
          engine.callOrder,
          containsAllInOrder(<String>['setSource', 'setVolume', 'play']),
        );
      },
    );

    test('playSelection is skipped when muted', () async {
      await manager.initialize();
      await manager.setMuted(true);
      engine.clear();

      await manager.playSelection(_selection);

      expect(engine.sources, isEmpty);
      expect(engine.callOrder, isEmpty);
    });

    test('playEvent resolves selection through theme resolver', () async {
      final selection = const SoundSelection.asset(
        'assets/audio/custom/focus.mp3',
      );
      final resolver = (AppSettingsModel _, SoundEvent __) => selection;
      manager = SoundManager(engine: engine, themeResolver: resolver);

      await manager.initialize();
      await manager.playEvent(SoundEvent.focusStart);

      expect(engine.sources.single, equals(selection));
    });

    test('stop and dispose forward to engine', () async {
      await manager.initialize();
      await manager.playSelection(_selection);

      await manager.stop();
      await manager.dispose();

      expect(engine.stopCount, equals(1));
      expect(engine.disposed, isTrue);
    });

    test('calling public APIs before initialize throws', () {
      expect(() => manager.setVolume(0.5), throwsStateError);
      expect(() => manager.playSelection(_selection), throwsStateError);
    });
  });
}

class FakeAudioEngine implements AudioPlaybackEngine {
  final List<String> callOrder = <String>[];
  final List<double> volumes = <double>[];
  final List<SoundSelection> sources = <SoundSelection>[];

  int stopCount = 0;
  bool disposed = false;

  void clear() {
    callOrder.clear();
    volumes.clear();
    sources.clear();
  }

  @override
  Future<void> dispose() async {
    callOrder.add('dispose');
    disposed = true;
  }

  @override
  Future<void> play() async {
    callOrder.add('play');
  }

  @override
  Future<void> setSource(SoundSelection selection) async {
    callOrder.add('setSource');
    sources.add(selection);
  }

  @override
  Future<void> setVolume(double volume) async {
    callOrder.add('setVolume');
    volumes.add(volume);
  }

  @override
  Future<void> stop() async {
    callOrder.add('stop');
    stopCount += 1;
  }
}

const SoundSelection _selection = SoundSelection.asset('assets/audio/test.mp3');

AppSettingsModel _settings({required bool enabled}) => AppSettingsModel(
  soundEnabled: enabled,
  vibrationEnabled: true,
  notificationsEnabled: true,
  theme: 'classic',
  language: 'es',
);
