import 'dart:typed_data';

abstract class ExportRepository {
  // Returns false if the user closed the save dialog.
  Future<bool> savePng(Uint8List bytes, String fileName);

  Future<void> sharePng(Uint8List bytes, String fileName);
}
