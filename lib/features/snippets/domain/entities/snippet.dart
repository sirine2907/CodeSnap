import 'package:equatable/equatable.dart';

import 'snippet_style.dart';

class Snippet extends Equatable {
  // Empty id means the snippet was never saved.
  final String id;
  final String title;
  final String code;
  final String language;
  final SnippetStyle style;
  final DateTime updatedAt;

  const Snippet({
    required this.id,
    required this.title,
    required this.code,
    required this.language,
    required this.style,
    required this.updatedAt,
  });

  bool get isNew => id.isEmpty;

  int get lineCount => code.split('\n').length;

  Snippet copyWith({
    String? id,
    String? title,
    String? code,
    String? language,
    SnippetStyle? style,
    DateTime? updatedAt,
  }) {
    return Snippet(
      id: id ?? this.id,
      title: title ?? this.title,
      code: code ?? this.code,
      language: language ?? this.language,
      style: style ?? this.style,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, code, language, style, updatedAt];
}
