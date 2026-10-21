part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LibraryStarted extends LibraryEvent {
  const LibraryStarted();
}

class LibrarySearchChanged extends LibraryEvent {
  final String query;

  const LibrarySearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class LibrarySnippetDeleted extends LibraryEvent {
  final String id;

  const LibrarySnippetDeleted(this.id);

  @override
  List<Object?> get props => [id];
}
