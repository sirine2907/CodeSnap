import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../export/domain/usecases/save_image.dart';
import '../../../export/domain/usecases/share_image.dart';
import '../../../snippets/domain/entities/snippet.dart';
import '../../../snippets/domain/entities/snippet_style.dart';
import '../../../snippets/domain/usecases/save_snippet.dart';
import '../sample_code.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  final SaveSnippet saveSnippet;
  final SaveImage saveImage;
  final ShareImage shareImage;

  EditorBloc({
    required this.saveSnippet,
    required this.saveImage,
    required this.shareImage,
  }) : super(EditorState(snippet: newSnippet())) {
    on<EditorCodeChanged>(_onCodeChanged);
    on<EditorTitleChanged>(_onTitleChanged);
    on<EditorLanguageChanged>(_onLanguageChanged);
    on<EditorStyleChanged>(_onStyleChanged);
    on<EditorSnippetOpened>(_onSnippetOpened);
    on<EditorNewSnippetStarted>(_onNewSnippetStarted);
    on<EditorSaveRequested>(_onSaveRequested);
    on<EditorImageExported>(_onImageExported);
  }

  void _onCodeChanged(EditorCodeChanged event, Emitter<EditorState> emit) {
    emit(EditorState(snippet: state.snippet.copyWith(code: event.code)));
  }

  void _onTitleChanged(EditorTitleChanged event, Emitter<EditorState> emit) {
    emit(EditorState(snippet: state.snippet.copyWith(title: event.title)));
  }

  void _onLanguageChanged(
    EditorLanguageChanged event,
    Emitter<EditorState> emit,
  ) {
    emit(EditorState(
      snippet: state.snippet.copyWith(language: event.language),
    ));
  }

  void _onStyleChanged(EditorStyleChanged event, Emitter<EditorState> emit) {
    emit(EditorState(snippet: state.snippet.copyWith(style: event.style)));
  }

  void _onSnippetOpened(
    EditorSnippetOpened event,
    Emitter<EditorState> emit,
  ) {
    emit(EditorState(snippet: event.snippet));
  }

  void _onNewSnippetStarted(
    EditorNewSnippetStarted event,
    Emitter<EditorState> emit,
  ) {
    // keep the style the user picked, people usually reuse it
    final fresh = newSnippet().copyWith(style: state.snippet.style);
    emit(EditorState(snippet: fresh));
  }

  Future<void> _onSaveRequested(
    EditorSaveRequested event,
    Emitter<EditorState> emit,
  ) async {
    emit(state.copyWith(status: EditorStatus.saving, message: ''));
    try {
      final saved = await saveSnippet(state.snippet);
      emit(state.copyWith(
        snippet: saved,
        status: EditorStatus.saved,
        message: 'Saved "${saved.title}"',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EditorStatus.error,
        message: 'Could not save the snippet',
      ));
    }
  }

  Future<void> _onImageExported(
    EditorImageExported event,
    Emitter<EditorState> emit,
  ) async {
    emit(state.copyWith(status: EditorStatus.exporting, message: ''));
    try {
      if (event.share) {
        await shareImage(event.bytes, state.snippet.title);
        emit(state.copyWith(status: EditorStatus.idle));
      } else {
        final saved = await saveImage(event.bytes, state.snippet.title);
        if (saved) {
          emit(state.copyWith(
            status: EditorStatus.exported,
            message: 'Image saved',
          ));
        } else {
          // user cancelled the dialog, nothing to say
          emit(state.copyWith(status: EditorStatus.idle));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        status: EditorStatus.error,
        message: 'Could not export the image',
      ));
    }
  }
}
