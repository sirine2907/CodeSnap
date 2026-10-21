import 'package:equatable/equatable.dart';

// How the code card looks. Saved together with the snippet.
class SnippetStyle extends Equatable {
  final String themeName;
  final String backgroundName;
  final double padding;
  final double fontSize;
  final bool showLineNumbers;
  final bool showWindowControls;

  const SnippetStyle({
    this.themeName = 'One Dark',
    this.backgroundName = 'Candy',
    this.padding = 48,
    this.fontSize = 14,
    this.showLineNumbers = true,
    this.showWindowControls = true,
  });

  SnippetStyle copyWith({
    String? themeName,
    String? backgroundName,
    double? padding,
    double? fontSize,
    bool? showLineNumbers,
    bool? showWindowControls,
  }) {
    return SnippetStyle(
      themeName: themeName ?? this.themeName,
      backgroundName: backgroundName ?? this.backgroundName,
      padding: padding ?? this.padding,
      fontSize: fontSize ?? this.fontSize,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      showWindowControls: showWindowControls ?? this.showWindowControls,
    );
  }

  @override
  List<Object?> get props => [
        themeName,
        backgroundName,
        padding,
        fontSize,
        showLineNumbers,
        showWindowControls,
      ];
}
