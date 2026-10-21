import 'dart:typed_data';

import '../repositories/export_repository.dart';

class SaveImage {
  final ExportRepository repository;

  SaveImage(this.repository);

  Future<bool> call(Uint8List bytes, String title) {
    return repository.savePng(bytes, makeFileName(title));
  }
}

// "My cool snippet!" -> "my-cool-snippet.png"
String makeFileName(String title) {
  var name = title.trim().toLowerCase();
  name = name.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  name = name.replaceAll(RegExp(r'^-+|-+$'), '');
  if (name.isEmpty) {
    name = 'codesnap';
  }
  return '$name.png';
}
