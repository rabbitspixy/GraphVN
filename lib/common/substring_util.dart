String? findBlockInXmlTag(String text, String tag) {
  final pattern = RegExp('<$tag>(.*?)</$tag>', dotAll: true);
  final matches = pattern.allMatches(text).toList();

  if (matches.length != 1) {
    return null;
  }

  return matches[0].group(1)?.trim();
}

String? findJavaScriptBlock(String text) {
  final pattern = RegExp(r'```javascript(.*?)```', dotAll: true);
  final matches = pattern.allMatches(text).toList();

  if (matches.isEmpty) {
    return null;
  }

  return matches[0].group(1)?.trim();
}

List<String> findBlockDoubleCurlyBraces(String text) {
  final pattern = RegExp(r'\{\{.*?\}\}', dotAll: true);
  final matches = pattern.allMatches(text).toList();
  return matches.map((match) => match.group(0)!).toList();
}

/// Удаляет из текста все блоки, заключённые в двойные круглые скобки `((...))`.
///
/// Поддерживает вложенные блоки: `outer ((inner content)) end` → `outer  end`.
/// Метод ищет все пары `((` и соответствующие `))` с учётом вложенности и удаляет блоки.
String removeDoubleParenthesesBlocks(String text) {
  final result = StringBuffer();
  int i = 0;
  
  while (i < text.length) {
    // Проверяем, начинается ли здесь блок `((`
    if (i + 1 < text.length && text[i] == '(' && text[i + 1] == '(') {
      int start = i;
      int level = 1;
      int j = i + 2;
      
      // Ищем соответствующую закрывающую пару `))`
      while (j < text.length && level > 0) {
        if (j + 1 < text.length && text[j] == '(' && text[j + 1] == '(') {
          level++;
          j += 2;
        } else if (j + 1 < text.length && text[j] == ')' && text[j + 1] == ')') {
          level--;
          j += 2;
        } else {
          j++;
        }
      }
      
      // Если уровень равен 0, нашли закрывающую пару - пропускаем весь блок
      if (level == 0) {
        i = j;
        continue;
      }
    }
    
    // Добавляем текущий символ в результат
    result.write(text[i]);
    i++;
  }
  
  return result.toString();
}
