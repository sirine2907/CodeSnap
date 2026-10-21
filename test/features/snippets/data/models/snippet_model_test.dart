import 'package:codesnap/features/snippets/data/models/snippet_model.dart';
import 'package:codesnap/features/snippets/domain/entities/snippet_style.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/sample_snippets.dart';

void main() {
  test('toJson and fromJson give back the same snippet', () {
    final model = SnippetModel.fromEntity(pythonSnippet);

    final result = SnippetModel.fromJson(model.toJson());

    expect(result, SnippetModel.fromEntity(pythonSnippet));
  });

  test('fromJson uses default style when style is missing', () {
    final json = {
      'id': '42',
      'title': 'old.dart',
      'code': 'void main() {}',
      'language': 'dart',
      'updatedAt': '2026-10-01T10:00:00.000',
    };

    final result = SnippetModel.fromJson(json);

    expect(result.style, const SnippetStyle());
    expect(result.title, 'old.dart');
  });
}
