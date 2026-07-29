import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:graph_vn/app_constants.dart';

class AiServers {
  static Process? _llamaProcess;
  static bool _llamaRunning = false;

  static Process? _sdProcess;
  static bool _sdRunning = false;

  static bool isRunningLlamaCpp() => _llamaRunning;

  static bool isRunningStableDiffusionCpp() => _sdRunning;

  static Future<void> ensureLlamaCppIsRunning() async {
    if (_llamaRunning) return;
    if (_sdRunning) {
      shutdownStableDiffusionCpp();
    }

    _llamaProcess = await Process.start(
      '${AppConstants.aiRuntimeDir}/${AppConstants.llamaDirName}/llama-server.exe',
      [
        //TODO: need review. a lot of unnecessary things
        '-m',
        '${AppConstants.aiRuntimeDir}/models/${AppConstants.llmMainFile}',
        '-ngl', '99',
        '-lv', '4',
        '--no-mmap',
        '--split-mode', 'none',
        '--ctx-size', '65536',
        '--parallel', AppConstants.llmParallelInference.toString(),
        '--batch-size', '1024',
        '-ctk', 'q8_0',
        '-ctv', 'q8_0',
        '--no-mmproj',
        '-fa', 'on',
      ],
      environment: {
        'GGML_VK_FORCE_MAX_ALLOCATION_SIZE': '2147483648',
      }
    );

    _llamaRunning = true;
    _llamaProcess!.exitCode.then((_) => _llamaRunning = false);

    final completer = Completer<void>();

    void onLine(String line) {
      print(line);
      if (line.toLowerCase().contains('listening on')) {
        if (!completer.isCompleted) completer.complete();
      }
    }

    _llamaProcess!.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(onLine);
    _llamaProcess!.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(onLine);

    _llamaProcess!.exitCode.then((code) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('llama.cpp exited with code $code before listening'));
      }
    });

    await completer.future;
  }

  static Future<void> shutdownLlamaCpp() async {
    if (!_llamaRunning) return;
    _llamaProcess?.kill();
    _llamaRunning = false;
    _llamaProcess = null;
  }

  static Future<void> ensureStableDiffusionCppIsRunning() async {
    if (_sdRunning) return;
    if (_llamaRunning) {
      shutdownLlamaCpp();
    }

    _sdProcess = await Process.start(
      '${AppConstants.aiRuntimeDir}/${AppConstants.sdDirName}/sd-server.exe',
      [
        '-v',
        '--diffusion-model', '${AppConstants.aiRuntimeDir}/models/${ZImageTurboConstants.zImageTurboFileName}',
        '--vae', '${AppConstants.aiRuntimeDir}/models/${ZImageTurboConstants.vaeFileName}',
        '--llm', '${AppConstants.aiRuntimeDir}/models/${ZImageTurboConstants.llmFileName}',
        '--cfg-scale', '1.0',
        '--offload-to-cpu',
        '--diffusion-fa',
        '--steps', '8',
        '--listen-port', '7860',
      ],
    );

    _sdRunning = true;
    _sdProcess!.exitCode.then((_) => _sdRunning = false);

    final completer = Completer<void>();

    void onLine(String line) {
      print(line);
      if (line.toLowerCase().contains('listening on')) {
        if (!completer.isCompleted) completer.complete();
      }
    }

    _sdProcess!.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(onLine);
    _sdProcess!.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(onLine);

    _sdProcess!.exitCode.then((code) {
      if (!completer.isCompleted) {
        completer.completeError(Exception('sd.cpp exited with code $code before listening'));
      }
    });

    await completer.future;
  }

  static Future<void> shutdownStableDiffusionCpp() async {
    if (!_sdRunning) return;
    _sdProcess?.kill();
    _sdRunning = false;
    _sdProcess = null;
  }
}
