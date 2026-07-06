import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:graph_vn/editor/modals/confirm_dialog.dart';
import 'package:graph_vn/editor/widgets/project_selector.dart';
import 'package:graph_vn/game/game_node.dart';
import 'package:graph_vn/game/game_transition.dart';
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
      //TODO: проверить зачем я сделал этот хоткей. Возможно он вообще не нужен.
      Player.progressState();
      return true;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyS && HardwareKeyboard.instance.isControlPressed) {
      GameState.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    GameState.stateUpdatedEvents.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
          onKeyEvent: _handleKey,
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
