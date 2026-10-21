import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:codesnap/core/errors/failures.dart';
import 'package:codesnap/features/editor/presentation/bloc/editor_bloc.dart';
import 'package:codesnap/features/export/domain/usecases/save_image.dart';
import 'package:codesnap/features/export/domain/usecases/share_image.dart';
import 'package:codesnap/features/snippets/domain/usecases/save_snippet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/sample_snippets.dart';

class MockSaveSnippet extends Mock implements SaveSnippet {}

class MockSaveImage extends Mock implements SaveImage {}

class MockShareImage extends Mock implements ShareImage {}

void main() {
  late MockSaveSnippet saveSnippet;
  late MockSaveImage saveImage;
  late MockShareImage shareImage;
  final bytes = Uint8List.fromList([1, 2, 3]);

  setUpAll(() {
    registerFallbackValue(pythonSnippet);
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    saveSnippet = MockSaveSnippet();
    saveImage = MockSaveImage();
    shareImage = MockShareImage();
  });

  EditorBloc buildBloc() {
    return EditorBloc(
      saveSnippet: saveSnippet,
      saveImage: saveImage,
      shareImage: shareImage,
    );
  }

  test('starts with the sample snippet that is not saved yet', () {
    final bloc = buildBloc();

    expect(bloc.state.snippet.isNew, isTrue);
    expect(bloc.state.snippet.code, isNotEmpty);
    expect(bloc.state.status, EditorStatus.idle);
  });

  blocTest<EditorBloc, EditorState>(
    'updates the code when it changes',
    build: buildBloc,
    seed: () => EditorState(snippet: pythonSnippet),
    act: (bloc) => bloc.add(const EditorCodeChanged('print("hi")')),
    expect: () => [
      EditorState(snippet: pythonSnippet.copyWith(code: 'print("hi")')),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'updates title, language and style',
    build: buildBloc,
    seed: () => EditorState(snippet: pythonSnippet),
    act: (bloc) {
      bloc.add(const EditorTitleChanged('new.py'));
      bloc.add(const EditorLanguageChanged('go'));
      bloc.add(EditorStyleChanged(
        pythonSnippet.style.copyWith(showLineNumbers: false),
      ));
    },
    verify: (bloc) {
      final snippet = bloc.state.snippet;
      expect(snippet.title, 'new.py');
      expect(snippet.language, 'go');
      expect(snippet.style.showLineNumbers, isFalse);
    },
  );

  blocTest<EditorBloc, EditorState>(
    'opens a snippet from the library',
    build: buildBloc,
    act: (bloc) => bloc.add(EditorSnippetOpened(goSnippet)),
    expect: () => [EditorState(snippet: goSnippet)],
  );

  blocTest<EditorBloc, EditorState>(
    'new snippet keeps the current style',
    build: buildBloc,
    seed: () => EditorState(snippet: goSnippet),
    act: (bloc) => bloc.add(const EditorNewSnippetStarted()),
    verify: (bloc) {
      expect(bloc.state.snippet.isNew, isTrue);
      expect(bloc.state.snippet.style, goSnippet.style);
    },
  );

  blocTest<EditorBloc, EditorState>(
    'save emits saving then saved with the saved snippet',
    build: () {
      when(() => saveSnippet(any())).thenAnswer((_) async => pythonSnippet);
      return buildBloc();
    },
    seed: () => EditorState(snippet: pythonSnippet.copyWith(id: '')),
    act: (bloc) => bloc.add(const EditorSaveRequested()),
    expect: () => [
      EditorState(
        snippet: pythonSnippet.copyWith(id: ''),
        status: EditorStatus.saving,
      ),
      EditorState(
        snippet: pythonSnippet,
        status: EditorStatus.saved,
        message: 'Saved "fetch_users.py"',
      ),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'save shows an error when it fails',
    build: () {
      when(() => saveSnippet(any())).thenThrow(Failure('disk full'));
      return buildBloc();
    },
    seed: () => EditorState(snippet: pythonSnippet),
    act: (bloc) => bloc.add(const EditorSaveRequested()),
    expect: () => [
      EditorState(snippet: pythonSnippet, status: EditorStatus.saving),
      EditorState(
        snippet: pythonSnippet,
        status: EditorStatus.error,
        message: 'Could not save the snippet',
      ),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'saving the image shows a message',
    build: () {
      when(() => saveImage(any(), any())).thenAnswer((_) async => true);
      return buildBloc();
    },
    seed: () => EditorState(snippet: pythonSnippet),
    act: (bloc) => bloc.add(EditorImageExported(bytes, share: false)),
    expect: () => [
      EditorState(snippet: pythonSnippet, status: EditorStatus.exporting),
      EditorState(
        snippet: pythonSnippet,
        status: EditorStatus.exported,
        message: 'Image saved',
      ),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'cancelling the save dialog goes back to idle without a message',
    build: () {
      when(() => saveImage(any(), any())).thenAnswer((_) async => false);
      return buildBloc();
    },
    seed: () => EditorState(snippet: pythonSnippet),
    act: (bloc) => bloc.add(EditorImageExported(bytes, share: false)),
    expect: () => [
      EditorState(snippet: pythonSnippet, status: EditorStatus.exporting),
      EditorState(snippet: pythonSnippet, status: EditorStatus.idle),
    ],
  );

  blocTest<EditorBloc, EditorState>(
    'share uses the share usecase with the snippet title',
    build: () {
      when(() => shareImage(any(), any())).thenAnswer((_) async {});
      return buildBloc();
    },
    seed: () => EditorState(snippet: pythonSnippet),
    act: (bloc) => bloc.add(EditorImageExported(bytes, share: true)),
    verify: (_) {
      verify(() => shareImage(bytes, 'fetch_users.py')).called(1);
      verifyNever(() => saveImage(any(), any()));
    },
  );
}
