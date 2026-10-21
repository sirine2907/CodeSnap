import '../../domain/entities/snippet.dart';
import '../../domain/entities/snippet_style.dart';

class SnippetModel extends Snippet {
  const SnippetModel({
    required super.id,
    required super.title,
    required super.code,
    required super.language,
    required super.style,
    required super.updatedAt,
  });

  factory SnippetModel.fromEntity(Snippet snippet) {
    return SnippetModel(
      id: snippet.id,
      title: snippet.title,
      code: snippet.code,
      language: snippet.language,
      style: snippet.style,
      updatedAt: snippet.updatedAt,
    );
  }

  factory SnippetModel.fromJson(Map<String, dynamic> json) {
    final styleJson = json['style'] as Map<String, dynamic>? ?? {};

    return SnippetModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Untitled',
      code: json['code'] as String? ?? '',
      language: json['language'] as String? ?? 'dart',
      style: SnippetStyle(
        themeName: styleJson['themeName'] as String? ?? 'One Dark',
        backgroundName: styleJson['backgroundName'] as String? ?? 'Candy',
        padding: (styleJson['padding'] as num? ?? 48).toDouble(),
        fontSize: (styleJson['fontSize'] as num? ?? 14).toDouble(),
        showLineNumbers: styleJson['showLineNumbers'] as bool? ?? true,
        showWindowControls: styleJson['showWindowControls'] as bool? ?? true,
      ),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'language': language,
      'style': {
        'themeName': style.themeName,
        'backgroundName': style.backgroundName,
        'padding': style.padding,
        'fontSize': style.fontSize,
        'showLineNumbers': style.showLineNumbers,
        'showWindowControls': style.showWindowControls,
      },
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
