import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/editor/presentation/bloc/editor_bloc.dart';
import 'features/editor/presentation/pages/editor_page.dart';
import 'features/settings/presentation/cubit/theme_cubit.dart';
import 'injection_container.dart';

class CodeSnapApp extends StatelessWidget {
  final bool isDark;

  const CodeSnapApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(saveDarkMode: sl(), isDark: isDark),
        ),
        BlocProvider(create: (_) => sl<EditorBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp(
            title: 'CodeSnap',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const EditorPage(),
          );
        },
      ),
    );
  }
}
