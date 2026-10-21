import 'package:bloc_test/bloc_test.dart';
import 'package:codesnap/core/errors/failures.dart';
import 'package:codesnap/features/snippets/domain/usecases/delete_snippet.dart';
import 'package:codesnap/features/snippets/domain/usecases/get_snippets.dart';
import 'package:codesnap/features/snippets/presentation/bloc/library_bloc.dart';
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
  });

  LibraryBloc buildBloc() {
    return LibraryBloc(getSnippets: getSnippets, deleteSnippet: deleteSnippet);
  }

  blocTest<LibraryBloc, LibraryState>(
    'loads the saved snippets',
    build: () {
      when(() => getSnippets()).thenAnswer((_) async => [pythonSnippet, goSnippet]);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LibraryStarted()),
    expect: () => [
      const LibraryState(status: LibraryStatus.loading),
      LibraryState(
        status: LibraryStatus.loaded,
        snippets: [pythonSnippet, goSnippet],
      ),
    ],
  );

  blocTest<LibraryBloc, LibraryState>(
    'shows an error when loading fails',
    build: () {
      when(() => getSnippets()).thenThrow(Failure('broken'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LibraryStarted()),
    expect: () => [
      const LibraryState(status: LibraryStatus.loading),
      const LibraryState(
        status: LibraryStatus.error,
        errorMessage: 'Could not load your snippets',
      ),
    ],
  );

  blocTest<LibraryBloc, LibraryState>(
    'search filters by title, language and code',
    build: buildBloc,
    seed: () => LibraryState(
      status: LibraryStatus.loaded,
      snippets: allSampleSnippets,
    ),
    act: (bloc) => bloc.add(const LibrarySearchChanged('SELECT')),
    verify: (bloc) {
      expect(bloc.state.visibleSnippets, [sqlSnippet]);
    },
  );

  test('search by language works too', () {
    final state = LibraryState(
      snippets: allSampleSnippets,
      query: 'rust',
    );

    expect(state.visibleSnippets, [rustSnippet]);
  });

  blocTest<LibraryBloc, LibraryState>(
    'deleting removes the snippet from the list',
    build: () {
      when(() => deleteSnippet(any())).thenAnswer((_) async {});
      return buildBloc();
    },
    seed: () => LibraryState(
      status: LibraryStatus.loaded,
      snippets: [pythonSnippet, goSnippet],
    ),
    act: (bloc) => bloc.add(LibrarySnippetDeleted(pythonSnippet.id)),
    expect: () => [
      LibraryState(status: LibraryStatus.loaded, snippets: [goSnippet]),
    ],
    verify: (_) {
      verify(() => deleteSnippet('1')).called(1);
    },
  );
}
