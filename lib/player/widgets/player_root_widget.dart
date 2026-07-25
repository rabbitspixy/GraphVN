import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/player/player_models.dart';
import 'background_image.dart';
import 'transition_buttons.dart';
import '../player.dart';
import 'speaker_narrative_block.dart';

class PlayerRootWidget extends StatefulWidget {
  const PlayerRootWidget({super.key});

  @override
  State<PlayerRootWidget> createState() => _PlayerRootWidgetState();
}

class _PlayerRootWidgetState extends State<PlayerRootWidget> {
  final FocusNode _focusNode = FocusNode(debugLabel: "Player Root Focus Node");
  int _selectedIndex = 0;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();
    Player.narrativeVersion.addListener(_onNarrativeVersionChanged);
  }

  @override
  void dispose() {
    Player.narrativeVersion.removeListener(_onNarrativeVersionChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onNarrativeVersionChanged() {
    setState(() {
      _selectedIndex = 0;
      _showButtons = false;
    });
  }

  void _onTextFinished() {
    setState(() {
      _showButtons = true;
    });
  }

  void _onTap() {
    _focusNode.requestFocus();
    Player.onScreenClick();
  }

  void _onArrowUp() {
    if (!_showButtons) return;
    final len = Player.buttons.value.length;
    if (len > 0) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1).clamp(0, len - 1);
      });
    }
  }

  void _onArrowDown() {
    if (!_showButtons) return;
    final len = Player.buttons.value.length;
    if (len > 0) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1).clamp(0, len - 1);
      });
    }
  }

  void _onEnter() {
    if (!_showButtons) return;
    final buttons = Player.buttons.value;
    if (_selectedIndex >= 0 && _selectedIndex < buttons.length) {
      Player.progressState(useTransition: buttons[_selectedIndex].transitionId);
    }
  }

  void _onButtonHover(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onButtonSubmit(int index) {
    final buttons = Player.buttons.value;
    if (index >= 0 && index < buttons.length) {
      Player.progressState(useTransition: buttons[index].transitionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stack = Stack(
      children: [
        const BackgroundImageWidget(),
        Positioned(
          top: 16,
          left: 16,
          child: ValueListenableBuilder<VariablesDiffDebug>(
            valueListenable: Player.variablesDiffDebug,
            builder: (context, diffDebug, child) {
              final textSpan = diffDebug.getChangedVariablesTableText();

              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(120, 0, 0, 0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: RichText(
                  text: textSpan,
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpeakerNarrativeBlock(onTextFinished: _onTextFinished),
                const SizedBox(height: 12),
                ValueListenableBuilder<List<ChoiseButton>>(
                  valueListenable: Player.buttons,
                  builder: (context, transitionList, child) {
                    return TransitionButtons(
                      transitions: transitionList,
                      selectedIndex: _selectedIndex,
                      show: _showButtons,
                      onHover: _onButtonHover,
                      onSubmit: _onButtonSubmit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.f5, shift: true): () async {
          GameState.restart();
          Player.progressState();
        },
        const SingleActivator(LogicalKeyboardKey.arrowUp): _onArrowUp,
        const SingleActivator(LogicalKeyboardKey.arrowDown): _onArrowDown,
        const SingleActivator(LogicalKeyboardKey.enter): _onEnter,
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: GestureDetector(onTap: _onTap, child: stack),
      ),
    );
  }
}
