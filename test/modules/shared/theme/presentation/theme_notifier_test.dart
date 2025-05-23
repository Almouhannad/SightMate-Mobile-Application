import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sight_mate/modules/shared/theme/theme.dart';

import 'theme_notifier_test.mocks.dart';

@GenerateMocks([ThemeRepository])
void main() {
  group('ThemeNotifier Unit Tests', () {
    late MockThemeRepository mockRepo;
    late ThemeNotifier notifier;
    late List<ThemeMode> notifiedModes;

    setUp(() {
      mockRepo = MockThemeRepository();
      // Default mock behavior: no saved mode yet
      when(mockRepo.loadThemeMode()).thenAnswer((_) async => null);
      when(mockRepo.lightTheme).thenReturn(ThemeData.light());
      when(mockRepo.darkTheme).thenReturn(ThemeData.dark());
      notifier = ThemeNotifier(mockRepo);
      notifiedModes = [];
      notifier.addListener(() {
        notifiedModes.add(notifier.mode);
      });
    });

    test('loads default system mode when no saved value', () async {
      // Wait for initial load
      await untilCalled(mockRepo.loadThemeMode());
      expect(notifier.initialized, isTrue);
      expect(notifier.mode, equals(ThemeMode.system));
    });

    test('loads saved dark mode', () async {
      when(mockRepo.loadThemeMode()).thenAnswer((_) async => ThemeMode.dark);
      // Re-create notifier to pick up new mock behavior
      notifier = ThemeNotifier(mockRepo);
      await untilCalled(mockRepo.loadThemeMode());
      expect(notifier.mode, equals(ThemeMode.dark));
    });

    test('updateMode notifies listeners and saves new mode', () async {
      await untilCalled(mockRepo.loadThemeMode());
      notifier.updateMode(ThemeMode.light);
      // Immediately notifies
      expect(notifiedModes, contains(ThemeMode.light));
      // Persists change
      verify(mockRepo.saveThemeMode(ThemeMode.light)).called(1);
    });

    test('lightTheme and darkTheme delegate to repository', () {
      expect(notifier.lightTheme, equals(mockRepo.lightTheme));
      expect(notifier.darkTheme, equals(mockRepo.darkTheme));
    });
  });
}
