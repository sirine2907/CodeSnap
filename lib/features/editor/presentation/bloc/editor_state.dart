part of 'editor_bloc.dart';

enum EditorStatus { idle, saving, saved, exporting, exported, error }

class EditorState extends Equatable {
  final Snippet snippet;
  final EditorStatus status;
  final String message;

  const EditorState({
    required this.snippet,
    this.status = EditorStatus.idle,
    this.message = '',
  });

  EditorState copyWith({
    Snippet? snippet,
    EditorStatus? status,
    String? message,
  }) {
    return EditorState(
      snippet: snippet ?? this.snippet,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [snippet, status, message];
}
