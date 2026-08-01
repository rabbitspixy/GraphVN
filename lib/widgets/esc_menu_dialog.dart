import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_vn/game/game_state.dart';
import 'package:graph_vn/gamepad_event_system.dart';
import 'package:universal_gamepad/universal_gamepad.dart';

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

class _MenuItem {
  final String label;
  final String? hotkey;
  final VoidCallback onTap;

  _MenuItem({
    required this.label,
    this.hotkey,
    required this.onTap,
  });
}

class _EscMenuOverlay extends StatefulWidget {
  const _EscMenuOverlay();

  @override
  State<_EscMenuOverlay> createState() => _EscMenuOverlayState();
}

class _EscMenuOverlayState extends State<_EscMenuOverlay> {
  int _selectedIndex = 0;
  late List<_MenuItem> _items;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _items = _buildItems();
  }

  List<_MenuItem> _buildItems() {
    return <_MenuItem>[
      if (GameState.showEditor.value)
        _MenuItem(
          label: 'Играть',
          hotkey: 'F1',
          onTap: () => Navigator.pop(context, EscMenuAction.toggleEditor),
        )
      else if (GameState.isEditorEnabled())
        _MenuItem(
          label: 'Редактор',
          hotkey: 'F1',
          onTap: () => Navigator.pop(context, EscMenuAction.toggleEditor),
        ),
      if (!GameState.showEditor.value)
        _MenuItem(
          label: 'Начать заново',
          hotkey: 'Shift+F5',
          onTap: () => Navigator.pop(context, EscMenuAction.restart),
        ),
      _MenuItem(
        label: 'Выйти',
        onTap: () => Navigator.pop(context, EscMenuAction.exit),
      ),
    ];
  }

  void _move(int delta) {
    final len = _items.length;
    if (len == 0) return;
    setState(() {
      _selectedIndex = (_selectedIndex + delta).clamp(0, len - 1);
    });
  }

  void _submit() {
    if (_selectedIndex >= 0 && _selectedIndex < _items.length) {
      _items[_selectedIndex].onTap();
    }
  }

  void _close() {
    Navigator.pop(context);
  }

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
          child: NotificationListener<GamepadButtonPressNotification>(
            onNotification: (GamepadButtonPressNotification event) {
              if (event.button == GamepadButton.dpadUp) {
                _move(-1);
                return true;
              }
              if (event.button == GamepadButton.dpadDown) {
                _move(1);
                return true;
              }
              if (event.button == GamepadButton.a) {
                _submit();
                return true;
              }
              if (event.button == GamepadButton.b) {
                _close();
                return true;
              }
              if (event.button == GamepadButton.start) {
                _close();
                return true;
              }
              return false;
            },
            child: CallbackShortcuts(
              bindings: <ShortcutActivator, VoidCallback>{
                const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
                const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
                const SingleActivator(LogicalKeyboardKey.enter): _submit,
                const SingleActivator(LogicalKeyboardKey.backspace): _close,
              },
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
                  child: _MenuCard(
                    items: _items,
                    selectedIndex: _selectedIndex,
                    onHover: (index) {
                      if (index != _selectedIndex) {
                        setState(() => _selectedIndex = index);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  final int selectedIndex;
  final ValueChanged<int> onHover;

  const _MenuCard({
    required this.items,
    required this.selectedIndex,
    required this.onHover,
  });

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
          ...List.generate(items.length, (index) {
            final item = items[index];
            return _MenuButton(
              label: item.label,
              hotkey: item.hotkey,
              isSelected: index == selectedIndex,
              onTap: item.onTap,
              onHover: () => onHover(index),
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  final String label;
  final String? hotkey;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onHover;

  const _MenuButton({
    required this.label,
    this.hotkey,
    required this.isSelected,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isSelected || _isHovered;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        onHover: (_) => widget.onHover(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: highlighted
                  ? Colors.white.withAlpha(25)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 17,
                    color: highlighted ? Colors.white : Colors.white,
                    fontWeight:
                        highlighted ? FontWeight.bold : FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                if (widget.hotkey != null)
                  Text(
                    widget.hotkey!,
                    style: TextStyle(
                      fontSize: 13,
                      color: highlighted
                          ? Colors.white.withAlpha(150)
                          : Colors.white38,
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
