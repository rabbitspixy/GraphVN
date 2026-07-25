import 'package:graph_vn/llm/llm_gateway.dart';

class ImagePromptGenerator {

  static Future<String?> writePrompt(String imageStyle, String textInNode, List<String> incomingTransitions, List<String> outgoingTransitions) async {
    final prompt = """
Твоя задача придумать промпт для генерации изображения, через DiT модель на английском языке.
Изображение используется в текстовом квесте или в визуальной новелле.

Текст который сейчас видит игрок:
$textInNode

Предыдущие переходы (нажатие на одну из кнопок, привело игрока к текущему тексту):
${incomingTransitions.map((x) => '- $x').join("\n")}

Все доступные переходы (кнопки, которые могут быть доступны игроку на выбор):
${outgoingTransitions.map((x) => '- $x').join("\n")}

Стиль изображения (полностью без изменений нужно скопировать в текст промпта):
$imageStyle


В ответе напиши только промпт на английском языке готовый для копирования, без каких либо пояснений.
    """;

    final responseText = await LLMGateway.request(prompt);
    if (responseText == null) {
      return null;
    }

    return responseText;
  }
}