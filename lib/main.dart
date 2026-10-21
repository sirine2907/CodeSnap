import 'package:flutter/material.dart';

import 'app.dart';
import 'features/settings/domain/usecases/get_dark_mode.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // load the theme before the first frame so it doesn't flash
  final isDark = await di.sl<GetDarkMode>()();

  runApp(CodeSnapApp(isDark: isDark));
}
