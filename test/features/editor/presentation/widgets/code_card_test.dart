import 'package:codesnap/features/editor/presentation/widgets/code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/sample_snippets.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));
  }

  testWidgets('shows the title and the line numbers', (tester) async {
    await tester.pumpWidget(wrap(CodeCard(snippet: goSnippet)));

    expect(find.text('main.go'), findsOneWidget);
    // go snippet has 16 lines
    expect(find.textContaining('15\n16'), findsOneWidget);
  });

  testWidgets('hides line numbers when turned off', (tester) async {
    final snippet = goSnippet.copyWith(
      style: goSnippet.style.copyWith(showLineNumbers: false),
    );

    await tester.pumpWidget(wrap(CodeCard(snippet: snippet)));

    expect(find.textContaining('15\n16'), findsNothing);
  });

  testWidgets('shows the code text', (tester) async {
    await tester.pumpWidget(wrap(CodeCard(snippet: sqlSnippet)));

    expect(find.textContaining('JOIN orders', findRichText: true), findsOneWidget);
  });
}
