import 'package:flutter/material.dart';
import 'package:graph_vn/player/components.dart';
import 'package:google_fonts/google_fonts.dart';
import 'background_image.dart';
import 'transition_buttons.dart';
import '../player.dart';
import 'speaker_narrative_block.dart';

class PlayerRootWidget extends StatelessWidget {
  const PlayerRootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Player.onScreenClick,
      child: Stack(
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
      ),
    );
  }
}
