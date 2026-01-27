int parseWithCoerce(String input, int min, int max) {
  // Keep only digits and minus sign
  String cleaned = input.replaceAll(RegExp(r'[^0-9-]'), '');
  // If min is positive, remove any minus sign
  if (min >= 0) {
    cleaned = cleaned.replaceAll('-', '');
  }
  // If the cleaned string is empty or just a minus, treat as 0
  int value = int.tryParse(cleaned) ?? 0;
  if (value < min) return min;
  if (value > max) return max;
  return value;
}
