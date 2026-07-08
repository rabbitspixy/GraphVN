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

  void _onTap() {
    _focusNode.requestFocus();
    Player.onScreenClick();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<List<ChoiseButton>>(
                valueListenable: Player.buttons,
                builder: (context, transitionList, child) {
                  return TransitionButtons(transitions: transitionList);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: const SpeakerNarrativeBlock(),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.f5, shift: true): () async {
          GameState.restart();
          Player.progressState();
        }
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: GestureDetector(onTap: _onTap, child: stack),
      ),
    );
  }
}
