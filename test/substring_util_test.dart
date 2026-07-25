import 'package:graph_vn/common/substring_util.dart';
import 'package:test/test.dart';

void main() {
  group('removeDoubleParenthesesBlocks', () {
    test('should remove single block', () {
      final text = 'Hello ((world))!';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals('Hello !'));
    });

    test('should remove multiple blocks', () {
      final text = '((first)) middle ((second)) end';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals(' middle  end'));
    });

    test('should remove nested blocks', () {
      final text = 'outer ((inner ((nested)) content)) end';
      final result = removeDoubleParenthesesBlocks(text);
      // Нежадный поиск удаляет вложенные пары последовательно
      expect(result, equals('outer  end'));
    });

    test('should handle multiline blocks', () {
      final text = 'before ((line1\nline2)) after';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals('before  after'));
    });

    test('should return original text if no blocks', () {
      final text = 'just normal text';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals(text));
    });

    test('should handle empty text', () {
      final text = '';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals(''));
    });

    test('should handle text with only blocks', () {
      final text = '((only blocks))';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals(''));
    });

    test('should remove single block', () {
      final text = 'Hello ((wor(l)d))!';
      final result = removeDoubleParenthesesBlocks(text);
      expect(result, equals('Hello !'));
    });
  });
}
