// Renders the app into docs/screenshots for the README.
// Run: flutter test test/screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'dart:convert';

import 'package:codesnap/app.dart';
import 'package:codesnap/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:codesnap/features/snippets/data/datasources/snippet_local_data_source.dart';
import 'package:codesnap/features/snippets/data/models/snippet_model.dart';
import 'package:codesnap/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/sample_snippets.dart';

// Without loading real fonts the test renders every letter as a box.
Future<void> loadFonts() async {
  final inter = FontLoader('Inter')
    ..addFont(rootBundle.load('assets/fonts/Inter.ttf'));
  final mono = FontLoader('JetBrainsMono')
    ..addFont(rootBundle.load('assets/fonts/JetBrainsMono.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([inter.load(), mono.load(), icons.load()]);
}

Future<void> openApp(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
  bool isDark = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final savedSnippets =
      allSampleSnippets.map((s) => SnippetModel.fromEntity(s).toJson()).toList();

  SharedPreferences.setMockInitialValues({
    SnippetLocalDataSourceImpl.snippetsKey: jsonEncode(savedSnippets),
    SettingsRepositoryImpl.darkModeKey: isDark,
  });
  await di.init(prefs: await SharedPreferences.getInstance());

  await tester.pumpWidget(CodeSnapApp(isDark: isDark));
  await settle(tester);
}

// shared preferences answers outside the fake clock, so give it real time
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pumpAndSettle();
  }
}

Future<void> takeScreenshot(String name) async {
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../../docs/screenshots/$name.png'),
  );
}

final windows = TargetPlatformVariant.only(TargetPlatform.windows);

void main() {
  setUpAll(loadFonts);

  testWidgets('editor dark', (tester) async {
    await openApp(tester);
    await takeScreenshot('01_editor_dark');
  }, variant: windows);

  testWidgets('editor light with a saved snippet', (tester) async {
    await openApp(tester, isDark: false);

    await tester.tap(find.byTooltip('My snippets'));
    await settle(tester);
    await tester.tap(find.text('fetch_users.py'));
    await settle(tester);

    await takeScreenshot('02_editor_light');
  }, variant: windows);

  testWidgets('library', (tester) async {
    await openApp(tester);

    await tester.tap(find.byTooltip('My snippets'));
    await settle(tester);

    await takeScreenshot('03_library');
  }, variant: windows);

  testWidgets('export sheet', (tester) async {
    await openApp(tester);

    await tester.tap(find.byTooltip('My snippets'));
    await settle(tester);
    await tester.tap(find.text('useDebounce.ts'));
    await settle(tester);
    await tester.tap(find.text('Export'));
    await settle(tester);

    await takeScreenshot('04_export');
  }, variant: windows);

  testWidgets('phone layout', (tester) async {
    await openApp(tester, size: const Size(430, 932));
    await takeScreenshot('05_phone');
  }, variant: windows);
}
