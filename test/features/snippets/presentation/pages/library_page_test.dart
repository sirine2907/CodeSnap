import 'package:codesnap/features/snippets/domain/usecases/delete_snippet.dart';
import 'package:codesnap/features/snippets/domain/usecases/get_snippets.dart';
import 'package:codesnap/features/snippets/presentation/bloc/library_bloc.dart';
import 'package:codesnap/features/snippets/presentation/pages/library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/sample_snippets.dart';

class MockGetSnippets extends Mock implements GetSnippets {}

class MockDeleteSnippet extends Mock implements DeleteSnippet {}

void main() {
  late MockGetSnippets getSnippets;
  late MockDeleteSnippet deleteSnippet;

  setUp(() {
    getSnippets = MockGetSnippets();
    deleteSnippet = MockDeleteSnippet();
    when(() => deleteSnippet(any())).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
        create: (_) => LibraryBloc(
          getSnippets: getSnippets,
          deleteSnippet: deleteSnippet,
        )..add(const LibraryStarted()),
        child: const LibraryPage(),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a message when there are no snippets', (tester) async {
    when(() => getSnippets()).thenAnswer((_) async => []);

    await pumpPage(tester);

    expect(find.textContaining('No snippets yet'), findsOneWidget);
  });

  testWidgets('shows a tile for each snippet', (tester) async {
    when(() => getSnippets()).thenAnswer((_) async => [pythonSnippet, goSnippet]);

    await pumpPage(tester);

    expect(find.text('fetch_users.py'), findsOneWidget);
    expect(find.text('main.go'), findsOneWidget);
  });

  testWidgets('search hides snippets that do not match', (tester) async {
    when(() => getSnippets()).thenAnswer((_) async => [pythonSnippet, goSnippet]);
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), 'python');
    await tester.pumpAndSettle();

    expect(find.text('fetch_users.py'), findsOneWidget);
    expect(find.text('main.go'), findsNothing);
  });

  testWidgets('delete asks first and then removes the snippet', (tester) async {
    when(() => getSnippets()).thenAnswer((_) async => [pythonSnippet]);
    await pumpPage(tester);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete snippet?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    verify(() => deleteSnippet('1')).called(1);
    expect(find.text('fetch_users.py'), findsNothing);
  });
}
