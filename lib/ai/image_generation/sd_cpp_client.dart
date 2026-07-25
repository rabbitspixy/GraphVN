import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:graph_vn/ai/ai_servers.dart';

class SDCppClient {
  static Future<Uint8List> generate(String prompt) async {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://127.0.0.1:7860',
      headers: {'Content-Type': 'application/json'},
    ));

    final extraArgs = '<sd_cpp_extra_args>{"seed": -1}</sd_cpp_extra_args>';

    final response = await dio.post('/v1/images/generations', data: {
      'prompt': prompt + extraArgs,
      'size': '1280x720',
      'output_format': 'jpeg',
      'output_compression': 80,
    });

    final data = response.data as Map<String, dynamic>;
    final b64json = (data['data'] as List<dynamic>).first['b64_json'] as String;
    return base64Decode(b64json);
  }
}

void main() async {
  await AiServers.ensureStableDiffusionCppIsRunning();
  final imgBytes = await SDCppClient.generate("Cyberpunk");
  File("sdcpp_test.jpg").writeAsBytesSync(imgBytes);
}