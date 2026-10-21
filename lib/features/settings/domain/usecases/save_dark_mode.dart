import '../repositories/settings_repository.dart';

class SaveDarkMode {
  final SettingsRepository repository;

  SaveDarkMode(this.repository);

  Future<void> call(bool isDark) {
    return repository.setDarkMode(isDark);
  }
}
