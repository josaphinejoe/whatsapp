import 'dart:io';

import 'package:example/sdk/services/file-service/file-service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DefaultFileService implements FileService {
  @override
  Future<File> moveFileToPermanentLocation(File sourceFile, String fileName) async {
    final permanentFilePath = await _getPermanentFilePath(fileName);
    await sourceFile.copy(permanentFilePath);
    await sourceFile.delete();
    return File(permanentFilePath);
  }

  Future<String> _getPermanentFilePath(String fileName) async {
    final directory = await (Platform.isIOS
        ? path_provider.getApplicationDocumentsDirectory()
        : path_provider.getApplicationSupportDirectory());
    final filePath = '${directory.path}/$fileName';
    return filePath;
  }
}
