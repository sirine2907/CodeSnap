import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/gruvbox-dark.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:flutter_highlight/themes/nord.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

// A syntax highlighting theme that the user can pick for the code card.
class CodeTheme {
  final String name;
  final Map<String, TextStyle> styles;

  const CodeTheme(this.name, this.styles);

  Color get background {
    return styles['root']?.backgroundColor ?? const Color(0xFF282C34);
  }

  Color get textColor {
    return styles['root']?.color ?? Colors.white;
  }

  bool get isDark => background.computeLuminance() < 0.4;
}

final List<CodeTheme> codeThemes = [
  CodeTheme('One Dark', atomOneDarkTheme),
  CodeTheme('Dracula', draculaTheme),
  CodeTheme('Night Owl', nightOwlTheme),
  CodeTheme('Monokai', monokaiSublimeTheme),
  CodeTheme('Nord', nordTheme),
  CodeTheme('Gruvbox', gruvboxDarkTheme),
  CodeTheme('VS Code', vs2015Theme),
  CodeTheme('One Light', atomOneLightTheme),
  CodeTheme('GitHub', githubTheme),
  CodeTheme('Solarized', solarizedLightTheme),
];

// If the saved name is not found (old data) we just use the first theme.
CodeTheme findCodeTheme(String name) {
  for (final theme in codeThemes) {
    if (theme.name == name) {
      return theme;
    }
  }
  return codeThemes.first;
}
