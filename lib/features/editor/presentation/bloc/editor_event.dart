part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object?> get props => [];
}

class EditorCodeChanged extends EditorEvent {
  final String code;

  const EditorCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class EditorTitleChanged extends EditorEvent {
  final String title;

  const EditorTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class EditorLanguageChanged extends EditorEvent {
  final String language;

  const EditorLanguageChanged(this.language);

  @override
  List<Object?> get props => [language];
}

// All the style controls (theme, background, sliders, switches) use this one.
class EditorStyleChanged extends EditorEvent {
  final SnippetStyle style;

  const EditorStyleChanged(this.style);

  @override
  List<Object?> get props => [style];
}

// When the user opens a snippet from the library.
class EditorSnippetOpened extends EditorEvent {
  final Snippet snippet;

  const EditorSnippetOpened(this.snippet);

  @override
  List<Object?> get props => [snippet];
}

class EditorNewSnippetStarted extends EditorEvent {
  const EditorNewSnippetStarted();
}

class EditorSaveRequested extends EditorEvent {
  const EditorSaveRequested();
}

// The page renders the card to PNG bytes and sends them here.
class EditorImageExported extends EditorEvent {
  final Uint8List bytes;
  final bool share;

  const EditorImageExported(this.bytes, {required this.share});

  @override
  List<Object?> get props => [bytes, share];
}
