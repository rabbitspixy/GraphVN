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
