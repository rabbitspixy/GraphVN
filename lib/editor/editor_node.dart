import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

class EditorNode {
  String id = Uuid().v4();
  String text = '';
  String label = '';

  int x = 0;
  int y = 0;
  bool isStart = false;

  void loadFromXml(XmlElement element) {
    id = element.getAttribute('id')!;
    text = element.getElement('text')?.innerText ?? '';
    x = int.parse(element.getAttribute('x')!);
    y = int.parse(element.getAttribute('y')!);
    isStart = bool.parse(element.getAttribute('isStart')!);
    label = element.getElement('label')?.innerText ?? '';
  }

  void writeToXml(XmlBuilder builder) {
    builder.element('node', nest: () {
      builder.attribute('id', id);
      builder.attribute('x', x);
      builder.attribute('y', y);
      builder.attribute('isStart', isStart);
      builder.element('text', nest: text);
      builder.element('label', nest: label);
    });
  }
}
