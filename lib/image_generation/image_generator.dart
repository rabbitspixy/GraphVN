import 'dart:convert';
import 'dart:io';

class ImageGenerator {
  static void start() async {
    String command = r'ComfyUI\.venv\Scripts\python.exe ComfyUI\z_image_turbo_workflow.py';

    final process = await Process.start('cmd', ['/c', command], runInShell: true);

    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      print('STDOUT: $line');
    });

    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((error) {
      print('STDERR: $error');
    });

    // Ожидаем завершения
    final exitCode = await process.exitCode;
    print('Image generation process exited with code: $exitCode');
  }
}