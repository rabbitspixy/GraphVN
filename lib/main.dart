import 'package:flutter/material.dart';
import 'package:touch_of_the_unknown/editor/editor_state.dart';
import 'engine.dart';
import 'package:flutter/services.dart';
import 'editor/editor.dart';
import 'game_player.dart';

void main() {
  updateNode();
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

  void toggleEditor() {
    if (_showEditor) {
      updateNode();
      setState(() {
        _showEditor = false;
      });
    } else {
      setState(() {
        _showEditor = true;
      });
    }
  }
  
  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f1) {
      toggleEditor();
      return true;
    }
    return false;
  }
  
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
  }
  
  @override
  void dispose() {
    // remember the current offset before the widget is destroyed
    _focusNode.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touch of the unknown',
      home: Scaffold(
        body: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          child: _showEditor
              ? const Editor()
              : const GamePlayer(),
        ),
      ),
    );
  }
}
