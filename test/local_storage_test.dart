import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_personalizado/models/models.dart';

void main() {
  late Directory tempDir;
  late Box<Category> categoryBox;
  late Box<Session> sessionBox;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);

    final categoryAdapter = CategoryAdapter();
    if (!Hive.isAdapterRegistered(categoryAdapter.typeId)) {
      Hive.registerAdapter(categoryAdapter);
    }

    final sessionAdapter = SessionAdapter();
    if (!Hive.isAdapterRegistered(sessionAdapter.typeId)) {
      Hive.registerAdapter(sessionAdapter);
    }

    final cycleAdapter = CycleAdapter();
    if (!Hive.isAdapterRegistered(cycleAdapter.typeId)) {
      Hive.registerAdapter(cycleAdapter);
    }

    final statsAdapter = StatsAdapter();
    if (!Hive.isAdapterRegistered(statsAdapter.typeId)) {
      Hive.registerAdapter(statsAdapter);
    }

    categoryBox = await Hive.openBox<Category>('categories_test');
    sessionBox = await Hive.openBox<Session>('sessions_test');
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('persists and retrieves a Category', () async {
    final category = Category(
      id: 'cat-1',
      name: 'Trabajo',
      color: 0xFF123456,
      icon: 'work_outline',
    );

    await categoryBox.put(category.id, category);

    final stored = categoryBox.get(category.id);
    expect(stored, isNotNull);
    expect(stored!.id, equals(category.id));
    expect(stored.name, equals(category.name));
    expect(stored.color, equals(category.color));
    expect(stored.icon, equals(category.icon));
  });

  test('persists and retrieves a Session with relationships intact', () async {
    final category = Category(
      id: 'cat-2',
      name: 'Estudio',
      color: 0xFF654321,
      icon: 'school',
    );
    await categoryBox.put(category.id, category);

    final startTime = DateTime.now().toUtc();
    final endTime = startTime.add(const Duration(minutes: 25));
    final session = Session(
      id: 'session-1',
      startTime: startTime,
      endTime: endTime,
      duration: 25,
      categoryId: category.id,
      completed: true,
    );

    await sessionBox.put(session.id, session);

    final stored = sessionBox.get(session.id);
    expect(stored, isNotNull);
    expect(stored!.id, equals(session.id));
    expect(stored.startTime, equals(session.startTime));
    expect(stored.endTime, equals(session.endTime));
    expect(stored.duration, equals(session.duration));
    expect(stored.categoryId, equals(session.categoryId));
    expect(stored.completed, isTrue);

    final storedCategory = categoryBox.get(stored.categoryId);
    expect(storedCategory, isNotNull);
    expect(storedCategory!.id, equals(category.id));
  });
}
