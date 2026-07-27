import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

abstract class ProjectFiles {
  Uint8List? readFile(String path);
  Future<void> writeFile(String path, Uint8List data);
  bool isReadOnly();

  static Future<ProjectFiles> create(String basePath) async {
    if (await Directory(basePath).exists()) {
      return FolderProjectFiles(basePath);
    }
    if (await File(basePath).exists() && basePath.endsWith('.zip')) {
      final archive = ZipDecoder().decodeBytes(await File(basePath).readAsBytes());
      return ZipProjectFiles(archive);
    }
    throw ArgumentError('Path must be a directory or a .zip file: $basePath');
  }
}

class FolderProjectFiles extends ProjectFiles {
  final String basePath;
  FolderProjectFiles(this.basePath);

  @override
  Uint8List? readFile(String path) {
    if (File('$basePath/$path').existsSync()) {
      return File('$basePath/$path').readAsBytesSync();
    } else {
      return null;
    }
  }

  @override
  Future<void> writeFile(String path, Uint8List data) async {
    final file = File('$basePath/$path');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data);
  }

  @override
  bool isReadOnly() => false;
}

class ZipProjectFiles extends ProjectFiles {
  final Archive _archive;
  ZipProjectFiles(this._archive);

  @override
  Uint8List? readFile(String path) {
    return _archive.findFile(path)?.readBytes();
  }

  @override
  Future<void> writeFile(String path, Uint8List data) async =>
      throw UnsupportedError('Cannot write to a zip archive');

  @override
  bool isReadOnly() => true;
}