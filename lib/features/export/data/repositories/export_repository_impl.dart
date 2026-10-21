import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/export_repository.dart';

class ExportRepositoryImpl implements ExportRepository {
  @override
  Future<bool> savePng(Uint8List bytes, String fileName) async {
    const pngType = XTypeGroup(label: 'PNG image', extensions: ['png']);

    final location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [pngType],
    );
    if (location == null) {
      return false;
    }

    var path = location.path;
    if (!path.toLowerCase().endsWith('.png')) {
      path = '$path.png';
    }

    try {
      await File(path).writeAsBytes(bytes);
      return true;
    } catch (e) {
      throw Failure('Could not save the image');
    }
  }

  @override
  Future<void> sharePng(Uint8List bytes, String fileName) async {
    // share_plus needs a real file, so write it to the temp folder first
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
    );
  }
}
