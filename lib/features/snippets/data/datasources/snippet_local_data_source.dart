import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../models/snippet_model.dart';

abstract class SnippetLocalDataSource {
  Future<List<SnippetModel>> getSnippets();

  Future<void> saveSnippet(SnippetModel snippet);

  Future<void> deleteSnippet(String id);
}

// Saves all snippets as one JSON list in shared preferences.
// It's simple and more than enough for a few hundred snippets.
class SnippetLocalDataSourceImpl implements SnippetLocalDataSource {
  static const String snippetsKey = 'saved_snippets';

  final SharedPreferences prefs;

  SnippetLocalDataSourceImpl(this.prefs);

  @override
  Future<List<SnippetModel>> getSnippets() async {
    final jsonString = prefs.getString(snippetsKey);
    if (jsonString == null) {
      return [];
    }

    try {
      final list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map((item) => SnippetModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Could not read saved snippets');
    }
  }

  @override
  Future<void> saveSnippet(SnippetModel snippet) async {
    final snippets = await getSnippets();

    final index = snippets.indexWhere((item) => item.id == snippet.id);
    if (index == -1) {
      snippets.insert(0, snippet);
    } else {
      snippets[index] = snippet;
    }

    await _write(snippets);
  }

  @override
  Future<void> deleteSnippet(String id) async {
    final snippets = await getSnippets();
    snippets.removeWhere((item) => item.id == id);
    await _write(snippets);
  }

  Future<void> _write(List<SnippetModel> snippets) async {
    final jsonString = jsonEncode(snippets.map((s) => s.toJson()).toList());
    final ok = await prefs.setString(snippetsKey, jsonString);
    if (!ok) {
      throw CacheException('Could not save snippets');
    }
  }
}
