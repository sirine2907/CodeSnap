import 'package:codesnap/features/snippets/domain/repositories/snippet_repository.dart';
import 'package:codesnap/features/snippets/domain/usecases/delete_snippet.dart';
import 'package:codesnap/features/snippets/domain/usecases/get_snippets.dart';
import 'package:codesnap/features/snippets/domain/usecases/save_snippet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/sample_snippets.dart';

class MockSnippetRepository extends Mock implements SnippetRepository {}

void main() {
  late MockSnippetRepository repository;

  setUpAll(() {
    registerFallbackValue(pythonSnippet);
  });

  setUp(() {
    repository = MockSnippetRepository();
  });

  group('GetSnippets', () {
    test('returns the snippets from the repository', () async {
      when(() => repository.getSnippets())
          .thenAnswer((_) async => [pythonSnippet, goSnippet]);

      final result = await GetSnippets(repository)();

      expect(result, [pythonSnippet, goSnippet]);
    });
  });

  group('SaveSnippet', () {
    setUp(() {
      when(() => repository.saveSnippet(any())).thenAnswer((_) async {});
    });

    test('gives a new snippet an id', () async {
      final newOne = pythonSnippet.copyWith(id: '');

      final saved = await SaveSnippet(repository)(newOne);

      expect(saved.id, isNotEmpty);
      verify(() => repository.saveSnippet(saved)).called(1);
    });

    test('keeps the id of an existing snippet and updates the date', () async {
      final saved = await SaveSnippet(repository)(pythonSnippet);

      expect(saved.id, pythonSnippet.id);
      expect(saved.updatedAt.isAfter(pythonSnippet.updatedAt), isTrue);
    });

    test('uses "Untitled" when the title is empty', () async {
      final saved = await SaveSnippet(repository)(
        pythonSnippet.copyWith(title: '   '),
      );

      expect(saved.title, 'Untitled');
    });
  });

  group('DeleteSnippet', () {
    test('asks the repository to delete by id', () async {
      when(() => repository.deleteSnippet(any())).thenAnswer((_) async {});

      await DeleteSnippet(repository)('3');

      verify(() => repository.deleteSnippet('3')).called(1);
    });
  });
}
