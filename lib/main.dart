import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:graph_vn/editor/widgets/project_selector.dart';
import 'package:graph_vn/js_test.dart';
import 'package:graph_vn/settings/app_settings.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:logger/logger.dart';
import 'player/player.dart';
import 'package:flutter/services.dart';
import 'editor/widgets/editor.dart';
import 'editor/pages/graph/editor_graph_page.dart';
import 'player/widgets/player_root_widget.dart';

final logger = Logger();

void main() {
  jsTest();
  GameState.loadLastSavedProject();
  Player.progressState();
  initWindowCloseHandler();
  runApp(const RootWidget());
}

void initWindowCloseHandler() {
  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    try {
      GameState.save();
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
      Player.progressState();
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
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f5 && HardwareKeyboard.instance.isShiftPressed) {
      GameState.restart();
      Player.progressState();
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f5) {
      Player.progressState();
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyS && HardwareKeyboard.instance.isControlPressed) {
      GameState.save();
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.delete) {
      final node = GameState.selectedNode;
      if (node != null) {
        GameState.deleteNode(node.id);
      }
      final transition = GameState.selectedTransition;
      if (transition != null) {
        GameState.deleteTransition(transition.id);
      }
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.home) {
      if (_showEditor) {
        final size = MediaQuery.of(context).size;
        EditorGraphPageState.instance?.resetOffset(size);
      }
      return true;
    }
    return false;
  }
  
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
    GameState.stateUpdatedEvents.listen((_) => setState(() {}));
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
          child: GameState.isProjectLoaded()
              ? Stack(
                  children: [
                    Visibility(
                      visible: _showEditor,
                      maintainState: true,
                      child: const EditorRootWidget(),
                    ),
                    Visibility(
                      visible: !_showEditor,
                      maintainState: true,
                      child: const PlayerRootWidget(),
                    ),
                  ],
                )
              : const ProjectSelector(),
        ),
      ),
    );
  }
}
