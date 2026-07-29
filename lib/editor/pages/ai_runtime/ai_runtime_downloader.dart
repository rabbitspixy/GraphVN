import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graph_vn/app_constants.dart';

enum AiRuntimeDownloadStatus { missing, checking, downloading, unpacking, installed }

class AiRuntimeItem {
  final String name;
  final String description;
  final Future<void> Function(AiRuntimeItem item) action;

  final String? filePath;

  AiRuntimeDownloadStatus _status = AiRuntimeDownloadStatus.missing;
  AiRuntimeDownloadStatus get status => _status;

  int completedBytes = 0;
  int totalBytes = 0;
  DateTime? _lastProgressNotify;

  final _listeners = <VoidCallback>[];

  AiRuntimeItem({
    required this.name,
    required this.description,
    required this.action,
    this.filePath,
  }) {
    _checkFileExists();
  }

  void _checkFileExists() async {
    if (filePath == null) return;
    final file = File(filePath!);
    final dir = Directory(filePath!);
    if (await file.exists() || await dir.exists()) {
      setStatus(AiRuntimeDownloadStatus.installed);
    }
  }

  void addListener(VoidCallback cb) => _listeners.add(cb);
  void removeListener(VoidCallback cb) => _listeners.remove(cb);

  void setProgress(int completed, int total) {
    completedBytes = completed;
    totalBytes = total;
    final now = DateTime.now();
    if (_lastProgressNotify == null ||
        now.difference(_lastProgressNotify!).inMilliseconds >= 200) {
      _lastProgressNotify = now;
      for (final l in _listeners) {
        l();
      }
    }
  }

  void setStatus(AiRuntimeDownloadStatus s) {
    _status = s;
    completedBytes = 0;
    totalBytes = 0;
    _lastProgressNotify = null;
    for (final l in _listeners) {
      l();
    }
  }

  Future<void> start() async {
    await action(this);
  }
}

// === Вспомогательный Sink для подсчёта SHA-256 ===

class _DigestSink implements Sink<Digest> {
  Digest? value;

  @override
  void add(Digest data) {
    value = data;
  }

  @override
  void close() {}
}

// === Загрузчик ===

class AiRuntimeDownloader {
  static final List<AiRuntimeItem> items = _initItems();

  static List<AiRuntimeItem> _initItems() => [
        AiRuntimeItem(
          name: ZImageTurboConstants.vaeFileName,
          description: 'VAE for Z-Image-Turbo',
          filePath: '${AppConstants.aiRuntimeDir}/models/${ZImageTurboConstants.vaeFileName}',
          action: (item) => _downloadModel(item, ZImageTurboConstants.vaeUrl, ZImageTurboConstants.vaeFileName, ZImageTurboConstants.vaeSha256),
        ),
        AiRuntimeItem(
          name: AppConstants.llmMainFile,
          description: 'Языковая модель для генерации текста',
          filePath: '${AppConstants.aiRuntimeDir}/models/${AppConstants.llmMainFile}',
          action: (item) => _downloadModel(item, AppConstants.llmMainUrl, AppConstants.llmMainFile, AppConstants.llmMainSha256),
        ),
        AiRuntimeItem(
          name: ZImageTurboConstants.llmFileName,
          description: 'Языковая модель для генерации изображений',
          filePath: '${AppConstants.aiRuntimeDir}/models/${ZImageTurboConstants.llmFileName}',
          action: (item) => _downloadModel(item, ZImageTurboConstants.llmUrl, ZImageTurboConstants.llmFileName, ZImageTurboConstants.llmSha256),
        ),
        AiRuntimeItem(
          name: ZImageTurboConstants.zImageTurboFileName,
          description: 'Модель генерации изображений',
          filePath: '${AppConstants.aiRuntimeDir}/models/${ZImageTurboConstants.zImageTurboFileName}',
          action: (item) => _downloadModel(item, ZImageTurboConstants.zImageTurboUrl, ZImageTurboConstants.zImageTurboFileName, ZImageTurboConstants.zImageTurboSha256),
        ),
        AiRuntimeItem(
          name: 'llama.cpp',
          description: 'Библиотеки и исполняемые файлы llama.cpp',
          filePath: '${AppConstants.aiRuntimeDir}/${AppConstants.llamaDirName}',
          action: (item) => _downloadAndExtractZip(item, AppConstants.llamaZipUrl, AppConstants.llamaDirName),
        ),
        AiRuntimeItem(
          name: 'sd.cpp',
          description: 'Библиотеки и исполняемые файлы stable-diffusion.cpp',
          filePath: '${AppConstants.aiRuntimeDir}/${AppConstants.sdDirName}',
          action: (item) => _downloadAndExtractZip(item, AppConstants.sdZipUrl, AppConstants.sdDirName),
        ),
      ];

  static Future<void> check() => Future.wait(items.map((i) => i.start()));

  // === Общие методы ===

  static Future<void> _downloadModel(AiRuntimeItem item, String url, String filename, String sha256) async {
    item.setStatus(AiRuntimeDownloadStatus.checking);
    final dir = Directory('${AppConstants.aiRuntimeDir}/models');
    await dir.create(recursive: true);
    final path = '${dir.path}/$filename';

    if (await _verifySha256(item, path, sha256)) {
      item.setStatus(AiRuntimeDownloadStatus.installed);
      return;
    }

    item.setStatus(AiRuntimeDownloadStatus.downloading);
    await Dio().download(url, path, onReceiveProgress: (count, total) {
      item.setProgress(count, total);
    });
    item.setStatus(AiRuntimeDownloadStatus.installed);
  }

  static Future<void> _downloadAndExtractZip(AiRuntimeItem item, String url, String targetDir) async {
    item.setStatus(AiRuntimeDownloadStatus.checking);
    final dir = Directory('${AppConstants.aiRuntimeDir}/$targetDir');

    if (await _dirExistsAndNotEmpty(dir.path)) {
      item.setStatus(AiRuntimeDownloadStatus.installed);
      return;
    }

    item.setStatus(AiRuntimeDownloadStatus.downloading);
    final tempZip = '${AppConstants.aiRuntimeDir}/$targetDir.zip';
    await Dio().download(url, tempZip, onReceiveProgress: (count, total) {
      item.setProgress(count, total);
    });

    item.setStatus(AiRuntimeDownloadStatus.unpacking);
    await _extractZip(tempZip, '${AppConstants.aiRuntimeDir}/$targetDir');
    await File(tempZip).delete();
    item.setStatus(AiRuntimeDownloadStatus.installed);
  }

  static Future<bool> _verifySha256(AiRuntimeItem item, String path, String expected) async {
    final file = File(path);
    if (!await file.exists()) return false;

    final total = await file.length();
    final sink = _DigestSink();
    final hashSink = sha256.startChunkedConversion(sink);
    final stream = file.openRead();
    int completed = 0;
    await for (final chunk in stream) {
      hashSink.add(chunk);
      completed += chunk.length;
      item.setProgress(completed, total);
    }
    hashSink.close();
    return sink.value!.toString() == expected.toLowerCase();
  }

  static Future<void> _extractZip(String zipPath, String outDir) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final entry in archive) {
      if (entry.isFile) {
        final outPath = '$outDir/${entry.name}';
        await File(outPath).create(recursive: true);
        await File(outPath).writeAsBytes(entry.content as List<int>);
      }
    }
  }

  static Future<bool> _dirExistsAndNotEmpty(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) return false;
    await for (final _ in dir.list()) {
      return true;
    }
    return false;
  }
}
