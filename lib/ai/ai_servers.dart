import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
      'airuntime/llama-b10107-bin-win-vulkan-x64/llama-server.exe',
      ['-m', 'airuntime/models/Qwen3.5-4B.Q8_0.gguf', '-ngl', '99', '-c', '16384'],
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
      'airuntime/sd-master-5114672-bin-win-vulkan-x64/sd-server.exe',
      [
        '-v',
        '--diffusion-model', 'airuntime/models/z_image_turbo-Q4_K.gguf',
        '--vae', r'airuntime/models\vae\model.safetensors',
        '--llm', r'models\Qwen3-4B-UD-Q6_K_XL.gguf',
        '--cfg-scale', '1.0',
        '-v',
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
