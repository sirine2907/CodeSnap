// Languages shown in the dropdown.
// [id] is the name the highlight package uses, [label] is what the user sees.
class CodeLanguage {
  final String id;
  final String label;
  final String extension;

  const CodeLanguage(this.id, this.label, this.extension);
}

const List<CodeLanguage> codeLanguages = [
  CodeLanguage('dart', 'Dart', 'dart'),
  CodeLanguage('javascript', 'JavaScript', 'js'),
  CodeLanguage('typescript', 'TypeScript', 'ts'),
  CodeLanguage('python', 'Python', 'py'),
  CodeLanguage('java', 'Java', 'java'),
  CodeLanguage('kotlin', 'Kotlin', 'kt'),
  CodeLanguage('swift', 'Swift', 'swift'),
  CodeLanguage('go', 'Go', 'go'),
  CodeLanguage('rust', 'Rust', 'rs'),
  CodeLanguage('cpp', 'C++', 'cpp'),
  CodeLanguage('cs', 'C#', 'cs'),
  CodeLanguage('php', 'PHP', 'php'),
  CodeLanguage('sql', 'SQL', 'sql'),
  CodeLanguage('xml', 'HTML', 'html'),
  CodeLanguage('css', 'CSS', 'css'),
  CodeLanguage('json', 'JSON', 'json'),
  CodeLanguage('yaml', 'YAML', 'yaml'),
  CodeLanguage('bash', 'Bash', 'sh'),
];

CodeLanguage findLanguage(String id) {
  for (final language in codeLanguages) {
    if (language.id == id) {
      return language;
    }
  }
  return codeLanguages.first;
}
