import 'package:graph_vn/game/code_repository.dart';
import 'package:test/test.dart';

void main() {
  group('CodeRepository', () {
    group('replaceInCode', () {
      test('should replace string in actions', () {
        final repo = CodeRepository();
        repo.actions['key'] = 'variables["Структура->Имя"] = 1;';
        repo.conditions['key'] = 'variables["Структура->Имя"] = 1;';
        repo.replaceables['key'] = 'variables["Структура->Имя"] = 1;';

        repo.replaceInCode('"Структура->Имя"', '"Структура->Новое Имя"');

        expect(repo.actions['key'], equals('variables["Структура->Новое Имя"] = 1;'));
        expect(repo.conditions['key'], equals('variables["Структура->Новое Имя"] = 1;'));
        expect(repo.replaceables['key'], equals('variables["Структура->Новое Имя"] = 1;'));
      });
    });
  });
}
