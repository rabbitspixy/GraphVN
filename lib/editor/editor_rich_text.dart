import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EditorRichText extends StatelessWidget {

  final List<ETextSpan> textSpans;

  EditorRichText(this.textSpans);


  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: textSpans.map((t) {
          if (t.tap != null) {
            return TextSpan(text: t.text, style: TextStyle(decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = t.tap);
          } else {
            return TextSpan(text: " ${t.text} ");
          }
        }).toList(),
      ),
    );
  }

  String toSimpleText() {
    return textSpans.map((t) => t.text).join(' ');
  }

}

class ETextSpan {

  final String text;
  final void Function()? tap;

  ETextSpan({required this.text, this.tap});
}