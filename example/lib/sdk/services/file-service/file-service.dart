import 'dart:io';

abstract class FileService {
  Future<File> moveFileToPermanentLocation(File sourceFile, String fileName);
}
