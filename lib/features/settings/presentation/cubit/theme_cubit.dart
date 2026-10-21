import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/save_dark_mode.dart';

// State is just "is dark mode on". A cubit is enough for a toggle.
class ThemeCubit extends Cubit<bool> {
  final SaveDarkMode saveDarkMode;

  ThemeCubit({required this.saveDarkMode, required bool isDark})
      : super(isDark);

  Future<void> toggle() async {
    final newValue = !state;
    emit(newValue);
    await saveDarkMode(newValue);
  }
}
