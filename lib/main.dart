import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:graph_vn/editor/project_selector.dart';
import 'package:graph_vn/app_settings.dart';
import 'package:graph_vn/common/rational_mapper.dart';
import 'package:graph_vn/editor/editor_state.dart';
import 'package:logger/logger.dart';
import 'player/player.dart';
import 'package:flutter/services.dart';
import 'editor/widgets/editor.dart';
import 'player/widgets/game_player.dart';

final logger = Logger();

void main() {
  MapperContainer.globals.use(RationalMapper());
  EditorState.loadLastSavedProject();
  Player.updateState();
  initWindowCloseHandler();
  runApp(const RootWidget());
}

void initWindowCloseHandler() {
  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    try {
      EditorState.save();
      saveAppSettings();
    } catch (e, s) {
      logger.e('project saving error', error: e, stackTrace: s);
      return false;
    }
    return true;
  });
}

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  bool _showEditor = false;
  final FocusNode _focusNode = FocusNode();

  void toggleEditor() {
    if (_showEditor) {
      Player.updateState();
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
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f5) {
      EditorState.restart();
      Player.updateState();
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyS && HardwareKeyboard.instance.isControlPressed) {
      EditorState.save();
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.delete) {
      final node = EditorState.selectedNode;
      if (node != null) {
        EditorState.deleteNode(node.id);
      }
      final transition = EditorState.selectedTransition;
      if (transition != null) {
        EditorState.deleteTransition(transition.id);
      }
    }
    return false;
  }
  
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
    EditorState.stateUpdatedEvents.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph VN',
      home: Scaffold(
        body: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          child: EditorState.isProjectLoaded()
              ? Stack(
                  children: [
                    Visibility(
                      visible: _showEditor,
                      maintainState: true,
                      child: const Editor(),
                    ),
                    Visibility(
                      visible: !_showEditor,
                      maintainState: true,
                      child: const GamePlayer(),
                    ),
                  ],
                )
              : const ProjectSelector(),
        ),
      ),
    );
  }
}
