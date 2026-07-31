import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/game/game_state.dart';

enum EscMenuAction { toggleEditor, restart, exit }

Future<EscMenuAction?> showEscMenuDialog(BuildContext context) {
  return showGeneralDialog<EscMenuAction>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'esc_menu',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const _EscMenuOverlay();
    },
  );
}

class _EscMenuOverlay extends StatelessWidget {
  const _EscMenuOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: Colors.black.withAlpha(150)),
              ),
            ),
          ),
        ),
        Center(
          child: Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.pop(context);
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: SingleChildScrollView(
              child: const _MenuCard(),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'МЕНЮ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 6,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 28),
          if (!GameState.showEditor.value && GameState.isEditorEnabled())
            _MenuButton(
              label: 'Редактор',
              hotkey: 'F1',
              onTap: () => Navigator.pop(context, EscMenuAction.toggleEditor),
            ),
          if (GameState.showEditor.value)
            _MenuButton(
              label: 'Играть',
              hotkey: 'F1',
              onTap: () => Navigator.pop(context, EscMenuAction.toggleEditor),
            ),
          if (!GameState.showEditor.value)
            _MenuButton(
              label: 'Начать заново',
              hotkey: 'Shift+F5',
              onTap: () => Navigator.pop(context, EscMenuAction.restart),
            ),
          const SizedBox(height: 4),
          _MenuButton(
            label: 'Выйти',
            onTap: () => Navigator.pop(context, EscMenuAction.exit),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  final String label;
  final String? hotkey;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    this.hotkey,
    required this.onTap,
  });

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
                color: _isHovered ? Colors.white.withAlpha(25) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 17,
                    color: _isHovered ? Colors.white : Colors.white,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                if (widget.hotkey != null)
                  Text(
                    widget.hotkey!,
                    style: TextStyle(
                      fontSize: 13,
                      color: _isHovered ? Colors.white.withAlpha(150) : Colors.white38,
                      decoration: TextDecoration.none,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
