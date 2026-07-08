import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:graph_vn/editor/widgets/project_selector.dart';
import 'package:graph_vn/js_test.dart';
import 'package:graph_vn/settings/app_settings.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:logger/logger.dart';
import 'player/player.dart';
import 'package:flutter/services.dart';
import 'editor/widgets/editor_root_widget.dart';
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
  final _rootFocusScope = FocusScopeNode(debugLabel: "My Custom Root Focus Node");
  bool _showEditor = false;

  void _toggleEditor() {
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

  @override
  void initState() {
    super.initState();
    GameState.stateUpdatedEvents.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _rootFocusScope.dispose();
  }

  Widget _project() {
    return IndexedStack(
      index: _showEditor ? 0 : 1,
      children: [
        const EditorRootWidget(),
        const PlayerRootWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph VN',
      home: Scaffold(
        body: FocusScope(
          autofocus: true,
          node: _rootFocusScope,
          onFocusChange: (hasFocus) {
            if (_rootFocusScope.hasPrimaryFocus) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _rootFocusScope.nextFocus();
              });
            }
          },
          child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.f1): () async {
                _toggleEditor();
              },
              const SingleActivator(
                LogicalKeyboardKey.keyS,
                control: true,
              ): () async {
                GameState.save();
              },
            },
            child: GameState.isProjectLoaded()
                ? _project()
                : const ProjectSelector(),
          ),
        ),
      ),
    );
  }
}
