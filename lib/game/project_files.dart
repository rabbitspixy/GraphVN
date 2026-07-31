import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

abstract class ProjectFiles {
  Uint8List? readFile(String path);
  bool exists(String path);
  Future<void> writeFile(String path, Uint8List data);
  bool isReadOnly();

  Future<void> saveAsZip(List<String> filePaths, String zipPath) async {
    final archive = Archive();
    for (final path in filePaths) {
      final data = readFile(path);
      if (data != null) {
        archive.addFile(ArchiveFile(path, data.length, data));
      }
    }
    final zipFile = File(zipPath);
    await zipFile.parent.create(recursive: true);
    await zipFile.writeAsBytes(ZipEncoder().encodeBytes(archive));
  }

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
  bool exists(String path) {
    return File('$basePath/$path').existsSync();
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
  bool exists(String path) {
    return _archive.findFile(path) != null;
  }

  @override
  Future<void> writeFile(String path, Uint8List data) async =>
      throw UnsupportedError('Cannot write to a zip archive');

  @override
  bool isReadOnly() => true;
}