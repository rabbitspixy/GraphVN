import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EditorRichText extends StatelessWidget {

  final List<ETextSpan> textSpans;

  const EditorRichText(this.textSpans, {super.key});


  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: textSpans.map((t) {
          if (t.tap != null) {
            return [
              TextSpan(text: t.text, style: TextStyle(decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap = t.tap),
              TextSpan(text: ' ')
            ];
          } else {
            return [TextSpan(text: "${t.text} ")];
          }
        }).expand((x) => x).toList(),
      ),
    );
  }
}

class ETextSpan {

  final String text;
  final void Function()? tap;

  ETextSpan({required this.text, this.tap});
}