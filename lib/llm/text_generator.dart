import 'package:llm_dart/llm_dart.dart';

class TextGenerator {
  //llama-server -hf ggml-org/gpt-oss-20b-GGUF  --ctx-size 32768 --jinja -ub 2048 -b 2048 --n-cpu-moe 10 --temp 0.0 --top-p 1.0 --top-k 0 --chat-template-kwargs "{""reasoning_effort"": ""medium""}"
  static final llamaCpp = ai()
      .openai()
      .baseUrl('http://127.0.0.1:8080/v1')
      .apiKey('sk-no-key-required')
      .model('ggml-org/gpt-oss-20b-GGUF')
      .temperature(0.1)
      .build();
  
  static final ollama = ai()
    .ollama()
    .baseUrl('http://localhost:11434')
    .model('gpt-oss:20b')
    .reasoning(true)
    .build();

  static void test(Future<ChatCapability> provider) async {
    final p = await provider;
    final messages = [ChatMessage.user('Tell me a joke about programming')];
    final response = await p.chat(messages);
    print(response.text);

    // Access thinking process (for supported models)
    if (response.thinking != null) {
      print('Model thinking: ${response.thinking}');
    }
  }
}