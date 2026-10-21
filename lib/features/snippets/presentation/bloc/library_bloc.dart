import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/snippet.dart';
import '../../domain/usecases/delete_snippet.dart';
import '../../domain/usecases/get_snippets.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetSnippets getSnippets;
  final DeleteSnippet deleteSnippet;

  LibraryBloc({required this.getSnippets, required this.deleteSnippet})
      : super(const LibraryState()) {
    on<LibraryStarted>(_onStarted);
    on<LibrarySearchChanged>(_onSearchChanged);
    on<LibrarySnippetDeleted>(_onSnippetDeleted);
  }

  Future<void> _onStarted(
    LibraryStarted event,
    Emitter<LibraryState> emit,
  ) async {
    emit(state.copyWith(status: LibraryStatus.loading));
    try {
      final snippets = await getSnippets();
      emit(state.copyWith(status: LibraryStatus.loaded, snippets: snippets));
    } catch (e) {
      emit(state.copyWith(
        status: LibraryStatus.error,
        errorMessage: 'Could not load your snippets',
      ));
    }
  }

  void _onSearchChanged(
    LibrarySearchChanged event,
    Emitter<LibraryState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  Future<void> _onSnippetDeleted(
    LibrarySnippetDeleted event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await deleteSnippet(event.id);
      final remaining =
          state.snippets.where((snippet) => snippet.id != event.id).toList();
      emit(state.copyWith(snippets: remaining));
    } catch (e) {
      emit(state.copyWith(
        status: LibraryStatus.error,
        errorMessage: 'Could not delete the snippet',
      ));
    }
  }
}
