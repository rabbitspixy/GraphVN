import 'package:graph_vn/ai/llm/llm_gateway.dart';
import 'package:graph_vn/common/substring_util.dart';
import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/variables.dart';

class JsCodeGenerator {

  static Future<String?> writeAction(String naturalLanguageAction) async {
    //TODO: Добавить в промпт "Сначала опиши шаги решения задачи на английском языке, а потом приступи к написанию кода" если модель не reasoning
    final prompt = """Ты переводчик с естественного языка, на язык Javascript.
Твоя задача писать код, который изменяет значения в словаре variables.
В блоке <keys_reference> находится справочник всех ключей объекта variables, и документация к каждому ключу.
В блоке <task> в произвольном виде написано, какие variables[key] нужно изменить, и как вычислить новые значения.

<task>
$naturalLanguageAction
</task>
<keys_reference>
${_buildKeysReference()}
</keys_reference>
<task>
$naturalLanguageAction
</task>
Тебе требуется в ответе написать только функцию doActions() на языке Javascript без комментирования кода, которая изменяет нужные значения внутри variables по указанию пользователя в блоке <task>
Если задача непонятна или невыполнима, напиши причину поместив её в блок <error></error>.
Код помести в блок ```javascript```.
    """;

    final responseText = await LLMGateway.request(prompt);
    if (responseText == null) {
      return null;
    }
    var errorBlock = findBlockInXmlTag(responseText, "error");
    if (errorBlock != null && errorBlock.isNotEmpty) {
      return null;
    }
    final code = findJavaScriptBlock(responseText);
    if (code == null) {
      return writeAction(naturalLanguageAction);
    }
    return code;
  }

  static Future<String?> writeCondition(String naturalLanguageCondition) async {
    //TODO: Добавить в промпт "Сначала опиши шаги решения задачи на английском языке, а потом приступи к написанию кода" если модель не reasoning
    final prompt = """Ты переводчик с естественного языка, на язык Javascript
Твоя задача писать условие на основе значений из словаря variables
В блоке <keys_reference> находится справочник всех ключей объекта variables, и документация к каждому ключу.
В блоке <task> в произвольном виде написано, какое условие требуется написать

<task>
$naturalLanguageCondition
</task>
<keys_reference>
${_buildKeysReference()}
</keys_reference>
<task>
$naturalLanguageCondition
</task>
Тебе требуется написать функцию testConditions() на языке Javascript без комментирования кода, которая вычисляет то же условие, что написано на естественном языке в блоке <task> и всегда возвращает boolean значение true или false.
Если задача непонятна или невыполнима, напиши причину поместив её в блок <error></error>.
Код помести в блок ```javascript```.
    """;

    final responseText = await LLMGateway.request(prompt);
    if (responseText == null) {
      return null;
    }
    var errorBlock = findBlockInXmlTag(responseText, "error");
    if (errorBlock != null && errorBlock.isNotEmpty) {
      return null;
    }
    final code = findJavaScriptBlock(responseText);
    if (code == null) {
      return writeCondition(naturalLanguageCondition);
    }
    return code;
  }

  static Future<String?> writeReplaceable(String replaceable) async {
    //TODO: Добавить в промпт "Сначала опиши шаги решения задачи на английском языке, а потом приступи к написанию кода" если модель не reasoning
    final prompt = """Ты переводчик с естественного языка, на язык Javascript
Твоя задача вычислить строку на основе значений из словаря variables
В блоке <keys_reference> находится справочник всех ключей объекта variables, и документация к каждому ключу.
В блоке <task> в произвольном виде написано, какую строку нужно вычислить

<task>
$replaceable
</task>
<keys_reference>
${_buildKeysReference()}
</keys_reference>
<task>
$replaceable
</task>
Тебе требуется написать функцию getText() на языке Javascript без комментирования кода, которая вычисляет строку, логика вычисления которой указана в блоке <task>.
Если задача непонятна или невыполнима, напиши причину поместив её в блок <error></error>.
Код помести в блок ```javascript```.
    """;

    final responseText = await LLMGateway.request(prompt);
    if (responseText == null) {
      return null;
    }
    var errorBlock = findBlockInXmlTag(responseText, "error");
    if (errorBlock != null && errorBlock.isNotEmpty) {
      return null;
    }
    final code = findJavaScriptBlock(responseText);
    if (code == null) {
      return writeReplaceable(replaceable);
    }
    return code;
  }

  static String _buildKeysReference() {
    final init = StringBuffer();
    init.writeln("---");

    for (final struct in GameState.structs) {
      for (final variable in struct.variables) {
        final key = "${struct.name}->${variable.name}";
        init.writeln("");
        init.writeln("variables[${toJsString(key)}]");
        init.writeln("Описание: ${variable.description}");
        if (variable is NumberVariable) {
          init.writeln("Возможные значения: Число");
        }
        if (variable is NamedVariable) {
          final possibleValues = GameState.namedValueTypes.findById(variable.typeId)?.values.map((x) => toJsString(x.name)).join(", ");
          init.writeln("Возможные значения: $possibleValues");
        }
        init.writeln("");
        init.writeln("---");
      }
    }
    return init.toString();
  }
}