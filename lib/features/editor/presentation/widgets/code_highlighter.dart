import 'package:flutter/painting.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

// Turns code into colored TextSpans using a highlight theme.
// The highlight package gives us a tree of nodes, each node can have a
// class name like "keyword" or "string" that we look up in the theme.
List<TextSpan> highlightCode(
  String code,
  String language,
  Map<String, TextStyle> theme,
) {
  try {
    final result = highlight.parse(code, language: language);
    final nodes = result.nodes ?? [];
    return nodes.map((node) => _nodeToSpan(node, theme)).toList();
  } catch (e) {
    // if the parser fails for some reason just show plain text
    return [TextSpan(text: code)];
  }
}

TextSpan _nodeToSpan(Node node, Map<String, TextStyle> theme) {
  TextStyle? style;
  if (node.className != null) {
    style = theme[node.className!];
  }

  if (node.value != null) {
    return TextSpan(text: node.value, style: style);
  }

  final children = <TextSpan>[];
  for (final child in node.children ?? <Node>[]) {
    children.add(_nodeToSpan(child, theme));
  }
  return TextSpan(style: style, children: children);
}
