import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

class EditorTransition {
  String id = Uuid().v4();
  String text = "";
  String from = "";
  String to = "";

  void loadFromXml(XmlElement element) {
    id = element.getAttribute('id')!;
    text = element.getElement('text')!.innerText;
    from = element.getAttribute('from')!;
    to = element.getAttribute('to')!;
  }

  void writeToXml(XmlBuilder builder) {
    builder.element('transition', nest: () {
      builder.attribute('id', id);
      builder.attribute('from', from);
      builder.attribute('to', to);
      builder.element('text', nest: text);
    });
  }
}