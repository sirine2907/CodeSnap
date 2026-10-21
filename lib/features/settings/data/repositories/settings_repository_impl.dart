import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String darkModeKey = 'dark_mode';

  final SharedPreferences prefs;

  SettingsRepositoryImpl(this.prefs);

  @override
  Future<bool> isDarkMode() async {
    // dark by default, it's a code app after all
    return prefs.getBool(darkModeKey) ?? true;
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    await prefs.setBool(darkModeKey, isDark);
  }
}
