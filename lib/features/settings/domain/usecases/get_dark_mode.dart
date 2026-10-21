import '../repositories/settings_repository.dart';

class GetDarkMode {
  final SettingsRepository repository;

  GetDarkMode(this.repository);

  Future<bool> call() {
    return repository.isDarkMode();
  }
}
