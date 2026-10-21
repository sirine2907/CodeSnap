import 'dart:typed_data';

import '../repositories/export_repository.dart';
import 'save_image.dart';

class ShareImage {
  final ExportRepository repository;

  ShareImage(this.repository);

  Future<void> call(Uint8List bytes, String title) {
    return repository.sharePng(bytes, makeFileName(title));
  }
}
