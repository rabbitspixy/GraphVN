import 'dart:convert';
import 'dart:io';

import 'package:dart_mappable/dart_mappable.dart';

part './generated/image_generator.mapper.dart';

class ImageGenerator {

  static Future<void> start(List<ImageGenerationSpec> specs) async {
    
    ImageGenerationSpecMapper.ensureInitialized();
    final json = MapperContainer.globals.toJson(specs);
    print(json);

    String command = r'ComfyUI\.venv\Scripts\python.exe ComfyUI\z_image_turbo_workflow.py';

    final process = await Process.start('cmd', ['/c', command], runInShell: true);

    process.stdin.write(json);
    await process.stdin.flush();
    await process.stdin.close();

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

    
    final exitCode = await process.exitCode;
    print('Image generation process exited with code: $exitCode');
  }
}

@MappableClass()
class ImageGenerationSpec with ImageGenerationSpecMappable {
  String prompt;
  String outputFile;

  ImageGenerationSpec({
    required this.prompt,
    required this.outputFile,
  });
}