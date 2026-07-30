import 'package:graph_vn/ai/llm/llm_gateway.dart';

class ImagePromptGenerator {

  static Future<String?> writePrompt(String gameDescription, String imageStyle, String textInNode, List<String> incomingTransitions, List<String> outgoingTransitions, List<String> previousNodeTexts) async {
    final prompt = """
Твоя задача придумать промпт для генерации изображения с помощью DiT модели.
Изображение используется в определенный момент в текстовом квесте или в визуальной новелле.


## Аннотация ко всему квесту целиком (это просто контекст игры, а не контекст текущего изображения):
$gameDescription

---

## Предыдущие переходы (нажатие на одну из кнопок, привело игрока к текущему тексту):
${incomingTransitions.map((x) => '- $x').join("\n")}

---

## Все доступные переходы (кнопки, которые могут быть доступны игроку на выбор):
${outgoingTransitions.map((x) => '- $x').join("\n")}

---

## Возможные варианты текста, который игрок видел до этого (в предыдущем состоянии игры)
${previousNodeTexts.map((t) => "<text>$t</text>").join("\n")}

---

## Текст который сейчас видит игрок, на основе которого нужно придумать промпт изображения
$textInNode

---

## Стиль изображения (полностью без изменений нужно скопировать в начало промпта):
$imageStyle

---

В ответе напиши только промпт для генерации изображения с помощью DiT модели.
Приветствуется написание подробного промпта в 2-3 абзаца. 
Промт на английском языке, готовый для копирования, без каких либо дополнительных пояснений или инструкций.
    """;

    final responseText = await LLMGateway.request(prompt);
    if (responseText == null) {
      return null;
    }

    return responseText;
  }
}