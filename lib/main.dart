import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/components.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'engine.dart';
import 'transition_buttons.dart';
import 'background_image.dart';
import 'package:flutter/services.dart';
import 'editor/editor.dart';

void main() {
  initGame();
  EditorState.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showEditor = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // remember the current offset before the widget is destroyed
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch of the unknown',
      home: Scaffold(
        body: RawKeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (event.isKeyPressed(LogicalKeyboardKey.f1)) {
              setState(() {
                _showEditor = !_showEditor;
              });
            }
          },
          child: _showEditor
              ? const Editor()
              : Stack(
                  children: [
                    BackgroundImageWidget(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ValueListenableBuilder<List<Transition>>(
                          valueListenable: transitions,
                          builder: (context, transitionList, child) {
                            return TransitionButtons(transitions: transitionList);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ValueListenableBuilder<String>(
                          valueListenable: narrativeText,
                          builder: (context, text, child) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(120, 0, 0, 0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                text,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
