import 'package:bloc_test/bloc_test.dart';
import 'package:codesnap/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:codesnap/features/settings/domain/usecases/save_dark_mode.dart';
import 'package:codesnap/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSaveDarkMode extends Mock implements SaveDarkMode {}

void main() {
  late MockSaveDarkMode saveDarkMode;

  setUp(() {
    saveDarkMode = MockSaveDarkMode();
    when(() => saveDarkMode(any())).thenAnswer((_) async {});
  });

  blocTest<ThemeCubit, bool>(
    'toggle switches from dark to light and saves it',
    build: () => ThemeCubit(saveDarkMode: saveDarkMode, isDark: true),
    act: (cubit) => cubit.toggle(),
    expect: () => [false],
    verify: (_) {
      verify(() => saveDarkMode(false)).called(1);
    },
  );

  group('SettingsRepositoryImpl', () {
    test('is dark by default', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = SettingsRepositoryImpl(await SharedPreferences.getInstance());

      expect(await repository.isDarkMode(), isTrue);
    });

    test('remembers light mode', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = SettingsRepositoryImpl(await SharedPreferences.getInstance());

      await repository.setDarkMode(false);

      expect(await repository.isDarkMode(), isFalse);
    });
  });
}
