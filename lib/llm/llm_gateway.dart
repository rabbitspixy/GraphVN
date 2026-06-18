import 'package:graph_vn/main.dart';
import 'package:llm_dart/llm_dart.dart';

class LLMGateway {
  //llama-server -hf ggml-org/gpt-oss-20b-GGUF  --ctx-size 32768 --jinja -ub 2048 -b 2048 --n-cpu-moe 10 --temp 0.0 --top-p 1.0 --top-k 0 --chat-template-kwargs "{""reasoning_effort"": ""medium""}"
  //llama-b8094-bin-win-cuda-13.1-x64\llama-server.exe -m qwen2.5-coder-7b-instruct-q5_k_m-00001-of-00002.gguf -ngl 99 -c 16384
  static final llamaCpp = ai()
      .openai()
      .baseUrl('http://127.0.0.1:8080/v1')
      .apiKey('sk-no-key-required')
      .temperature(0.3)
      .topP(0.9)
      .topK(50)
      .build();

  static final ollama = ai()
      .ollama()
      .baseUrl('http://localhost:11434')
      .model('gpt-oss:20b')
      .reasoning(true)
      .build();

  static Future<String?> request(String prompt) async {
    final ai = await llamaCpp;
    final messages = [ChatMessage.user(prompt)];
    logger.d("request");
    final response = await ai.chat(messages);
    final responseText = response.text;
    logger.d("AI request\n$prompt");
    logger.d("AI response\n$responseText");
    if (responseText == null) {
      return null;
    } else {
      return responseText;
    }
  }
}