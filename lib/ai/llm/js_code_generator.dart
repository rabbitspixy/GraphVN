import 'package:graph_vn/ai/llm/llm_gateway.dart';
import 'package:graph_vn/common/substring_util.dart';
import 'package:graph_vn/common/js_util.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/game/variables.dart';

class JsCodeGenerator {

  static Future<String?> writeAction(String naturalLanguageAction) async {
    //TODO: Добавить в промпт "Сначала опиши шаги решения задачи на английском языке, а потом приступи к написанию кода" если модель не reasoning
    final prompt = """Инструкция:
В блоке <init></init> указана часть кода на языке javascript. Там происходит заполнение структуры variables, с документацией к каждому ключу.
В блоке <task></task> указана задача на изменение значений в структуре variables.
Тебе требуется написать функцию doActions() на языке Javascript без комментирования кода, которая выполняет указанную задачу.
Попробуй по описанию каждого ключа в variables, и по указаной задаче понять, значения каких ключей требуется изменить.

Учитывай что во время вызова doActions(), значения variables могут оказаться другими.
В ответе не должно быть начального кода из блока <init>.
Если задача непонятна или невыполнима, напиши причину поместив её в блок <error></error>.
Код помести в блок ```javascript```.


<init>
${_buildInit()}
</init>
<task>
$naturalLanguageAction
</task>
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
    final prompt = """Инструкция:
В блоке <init></init> указана часть кода на языке javascript. Там происходит заполнение структуры variables, с документацией к каждому ключу.
В блоке <task></task> указана задача на проверку значений в variables.
Тебе требуется написать функцию testConditions() на языке Javascript без комментирования кода, которая выполняет указанную задачу и всегда возвращает boolean значение true или false.
Попробуй по описанию каждого ключа в variables, и по указаной задаче понять, значения каких ключей требуется использовать.
Учитывай что во время вызова testConditions(), значения variables могут оказаться другими.
В ответе не должно быть начального кода из блока <init>.
Если задача непонятна или невыполнима, напиши причину поместив её в блок <error></error>.
Код помести в блок ```javascript```.


<init>
${_buildInit()}
</init>
<task>
$naturalLanguageCondition
</task>
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
    final prompt = """Инструкция:
В блоке <init></init> указана часть кода на языке javascript. Там происходит заполнение структуры variables, с документацией к каждому ключу.
В блоке <task></task> указана задача на создание строки с использованием значений из variables (могут потребоваться какие-то строковые или математические манипуляции со значениями).
Тебе требуется написать функцию getText() на языке Javascript без комментирования кода, которая выполняет указанную задачу и всегда возвращает строку.
Попробуй по описанию каждого ключа в variables и по указаной задаче понять, значения каких ключей требуется использовать, или наоборот задача не требует использования ниодного значения из variables.
Учитывай что во время вызова getText(), значения variables могут оказаться другими.
В ответе не должно быть начального кода из блока <init>.
Если задача непонятна или невыполнима, напиши причину поместив её в блок <error></error>.
Код помести в блок ```javascript```.


<init>
${_buildInit()}
</init>
<task>
$replaceable
</task>
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

  static String _buildInit() {
    final init = StringBuffer();
    init.writeln("variables = {};");

    for (final struct in GameState.structs) {
      for (final variable in struct.variables) {
        final key = "${struct.name}->${variable.name}";
        init.writeln("");
        init.writeln("//Название: $key");
        init.writeln("//Описание: ${variable.description}");
        if (variable is NamedVariable) {
          final possibleValues = GameState.namedValueTypes.findById(variable.typeId)?.values.map((x) => toJsString(x.name)).join(", ");
          init.writeln("//Возможные значения: $possibleValues");
        }
        init.writeln("variables[${toJsString(key)}] = ${variable.initialValueAsJsCode()}");
      }
    }
    return init.toString();
  }
}