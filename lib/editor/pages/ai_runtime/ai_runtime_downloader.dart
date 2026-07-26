import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graph_vn/app_constants.dart';

// === Константы моделей ===

const _vaeUrl = 'https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors';
const _vaeFile = 'ae.safetensors';
const _vaeSha256 = 'afc8e28272cd15db3919bacdb6918ce9c1ed22e96cb12c4d5ed0fba823529e38';

const _llmMainUrl = 'https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-Q8_0.gguf';
const _llmMainFile = 'Qwen3.5-4B.Q8_0.gguf';
const _llmMainSha256 = '10cc391b403021dd11c614679d2fd92f611c3681d29e29651b717316965d61e1';

const _llmSecondUrl = 'https://huggingface.co/unsloth/Qwen3-4B-GGUF/resolve/main/Qwen3-4B-UD-Q6_K_XL.gguf';
const _llmSecondFile = 'Qwen3-4B-UD-Q6_K_XL.gguf';
const _llmSecondSha256 = 'ac0767b5e9c9f16efe57ce422253a33747970c166c3131c4d4d59d20511f07e1';

const _zImageTurboUrl = 'https://huggingface.co/leejet/Z-Image-Turbo-GGUF/resolve/main/z_image_turbo-Q4_K.gguf';
const _zImageTurboFile = 'z_image_turbo-Q4_K.gguf';
const _zImageTurboSha256 = '14b375ab4f226bc5378f68f37e899ef3c2242b8541e61e2bc1aff40976086fbd';

// === Константы zip-архивов ===

const _llamaZipUrl = 'https://github.com/ggml-org/llama.cpp/releases/download/b10107/llama-b10107-bin-win-vulkan-x64.zip';
// const _llamaZipSha256 = 'c5b3a5ee8319b1eccbb748a54390aa806bbf7d1aceeea452e4c57921d113e53e';
const _llamaDirName = 'llama-b10107-bin-win-vulkan-x64';

const _sdZipUrl = 'https://github.com/leejet/stable-diffusion.cpp/releases/download/master-789-5114672/sd-master-5114672-bin-win-vulkan-x64.zip';
// const _sdZipSha256 = 'cb5fb173430147d83fa3439040be1e1d97906c2e8fb3a06cc8afb761ea98ba17';
const _sdDirName = 'sd-master-5114672-bin-win-vulkan-x64';

// === Статус ===

enum AiRuntimeDownloadStatus { missing, checking, downloading, unpacking, installed }

// === Элемент ===

class AiRuntimeItem {
  final String name;
  final String description;
  final Future<void> Function(AiRuntimeItem item) action;

  // TODO: заполнить пути к файлам
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
    setStatus(AiRuntimeDownloadStatus.checking);
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
          name: 'VAE',
          description: 'VAE for Z-Image-Turbo',
          filePath: '${AppConstants.aiRuntimeDir}/models/ae.safetensors',
          action: (item) => _downloadModel(item, _vaeUrl, _vaeFile, _vaeSha256),
        ),
        AiRuntimeItem(
          name: 'Qwen3.5-4B.Q8_0.gguf',
          description: 'Языковая модель для генерации текста',
          filePath: '${AppConstants.aiRuntimeDir}/models/Qwen3.5-4B.Q8_0.gguf',
          action: (item) => _downloadModel(item, _llmMainUrl, _llmMainFile, _llmMainSha256),
        ),
        AiRuntimeItem(
          name: 'Qwen3-4B-UD-Q6_K_XL.gguf',
          description: 'Языковая модель для генерации изображений',
          filePath: '${AppConstants.aiRuntimeDir}/models/Qwen3-4B-UD-Q6_K_XL.gguf',
          action: (item) => _downloadModel(item, _llmSecondUrl, _llmSecondFile, _llmSecondSha256),
        ),
        AiRuntimeItem(
          name: 'z_image_turbo-Q4_K.gguf',
          description: 'Модель генерации изображений',
          filePath: '${AppConstants.aiRuntimeDir}/models/z_image_turbo-Q4_K.gguf',
          action: (item) => _downloadModel(item, _zImageTurboUrl, _zImageTurboFile, _zImageTurboSha256),
        ),
        AiRuntimeItem(
          name: 'llama.cpp',
          description: 'Библиотеки и исполняемые файлы llama.cpp',
          filePath: '${AppConstants.aiRuntimeDir}/llama-b10107-bin-win-vulkan-x64',
          action: (item) => _downloadAndExtractZip(item, _llamaZipUrl, _llamaDirName),
        ),
        AiRuntimeItem(
          name: 'sd.cpp',
          description: 'Библиотеки и исполняемые файлы stable-diffusion.cpp',
          filePath: '${AppConstants.aiRuntimeDir}/sd-master-5114672-bin-win-vulkan-x64',
          action: (item) => _downloadAndExtractZip(item, _sdZipUrl, _sdDirName),
        ),
      ];

  static Future<void> check() => Future.wait(items.map((i) => i.start()));

  // === Общие методы ===

  static Future<void> _downloadModel(AiRuntimeItem item, String url, String filename, String sha256) async {
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
