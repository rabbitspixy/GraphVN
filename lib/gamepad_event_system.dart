import 'package:flutter/widgets.dart';
import 'package:graph_vn/main.dart';
import 'package:universal_gamepad/universal_gamepad.dart';

void listenGamepadEvents() {
  logger.d("Gamepad events listening");
  Gamepad.instance.events.listen((event) {
    if (event is GamepadButtonEvent) {
      if (event.pressed) {
        final FocusNode? currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus != null && currentFocus.context != null) {
          GamepadButtonPressNotification(event.button)
              .dispatch(currentFocus.context);
        }
      }
    }

    if (event is GamepadConnectionEvent) {
      logger.i(event);
    }
  });
}

class GamepadButtonPressNotification extends Notification {
  final GamepadButton button;

  GamepadButtonPressNotification(this.button);
}