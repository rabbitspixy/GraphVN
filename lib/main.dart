import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:graph_vn/editor/widgets/project_selector.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/js_test.dart';
import 'package:graph_vn/settings/app_settings.dart';
import 'package:graph_vn/widgets/esc_menu_dialog.dart';
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';
import 'player/player.dart';
import 'package:flutter/services.dart';
import 'editor/widgets/editor_root_widget.dart';
import 'player/widgets/player_root_widget.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  jsTest();
  GameState.loadLastSavedProject();
  Player.progressState();
  initWindowCloseHandler();

  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    fullScreen: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const RootWidget());
}

void initWindowCloseHandler() {
  FlutterWindowClose.setWindowShouldCloseHandler(() async {
    try {
      GameState.save();
      saveAppSettings();
    } catch (e, st) {
      logger.e('project saving error', error: e, stackTrace: st);
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
  bool _showEditor = true;
  bool _isEscMenuOpen = false;
  BuildContext? _navigatorContext;

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

  void _toggleFullscreen() async {
    bool isFullScreen = await windowManager.isFullScreen();
    await windowManager.setFullScreen(!isFullScreen);
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
              const SingleActivator(LogicalKeyboardKey.escape): () async {
                if (_isEscMenuOpen) return;
                _isEscMenuOpen = true;
                final action = await showEscMenuDialog(_navigatorContext!, _showEditor);
                _isEscMenuOpen = false;
                if (action == null) return;
                switch (action) {
                  case EscMenuAction.toggleEditor:
                    _toggleEditor();
                  case EscMenuAction.restart:
                    GameState.restart();
                    Player.progressState();
                  case EscMenuAction.exit:
                    windowManager.close();
                }
              },
              const SingleActivator(LogicalKeyboardKey.f1): () async {
                _toggleEditor();
              },
              const SingleActivator(
                LogicalKeyboardKey.keyS,
                control: true,
              ): () async {
                GameState.save();
              },
              const SingleActivator(LogicalKeyboardKey.f11): () async {
                _toggleFullscreen();
              },
            },
            child: Builder(
              builder: (innerContext) {
                _navigatorContext = innerContext;
                return GameState.isProjectLoaded()
                    ? _project()
                    : const ProjectSelector();
              },
            ),
          ),
        ),
      ),
    );
  }
}
