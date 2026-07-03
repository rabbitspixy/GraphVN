import 'package:flutter/foundation.dart';

class GameStill {
  final PlayerImageInfo Function() imageInfo;
  final String Function() text;
  final VoidCallback? onEnter;
  final VoidCallback? onLeave;
  final List<ChoiseButton> buttons;

  GameStill({
    required this.imageInfo,
    required this.text,
    this.onEnter,
    this.onLeave,
    required this.buttons,
  });
}

class ChoiseButton {
  final String text;
  final String transitionId;

  ChoiseButton({
    required this.text,
    required this.transitionId,
  });
}

class PlayerImageInfo {
  final String? path;
  final int red;
  final int green;
  final int blue;
  final double shakeIntensity;
  final double scale;
  final int animationDuration;

  PlayerImageInfo({
    this.path,
    this.red = 0,
    this.green = 0,
    this.blue = 0,
    this.shakeIntensity = 0.0,
    this.scale = 1.0,
    this.animationDuration = 0,
  });
}

class VariablePreviousCurrentValue {
  final String key;
  final String? previous;
  final String? current;

  VariablePreviousCurrentValue({
    required this.key,
    required this.previous,
    required this.current,
  });
}

class VariablesDiffDebug {
  final Map<String, String> previous;
  final Map<String, String> current;

  VariablesDiffDebug({
    required this.previous,
    required this.current,
  });

  List<VariablePreviousCurrentValue> getChangedVariables() {
    final List<VariablePreviousCurrentValue> result = [];
    final allKeys = {...previous.keys, ...current.keys};

    for (final key in allKeys) {
      final previousValue = previous[key];
      final currentValue = current[key];

      if (previousValue != currentValue) {
        result.add(
          VariablePreviousCurrentValue(
            key: key,
            previous: previousValue,
            current: currentValue,
          ),
        );
      }
    }

    result.sort((a, b) => a.key.compareTo(b.key));
    return result;
  }

  String getChangedVariablesTableText() {
    final changedVariables = getChangedVariables();

    if (changedVariables.isEmpty) {
      return '';
    }

    // Находим максимальную длину key для выравнивания первого столбца
    int maxKeyLength = 0;
    for (final item in changedVariables) {
      maxKeyLength = item.key.length > maxKeyLength ? item.key.length : maxKeyLength;
    }

    final buffer = StringBuffer();
    for (final item in changedVariables) {
      // Первый столбец: key
      buffer.write(item.key);
      // Отступ после первого столбца (3 пробела после самого длинного key)
      final padding1 = ' ' * (maxKeyLength - item.key.length + 3);
      buffer.write(padding1);

      // Второй столбец: previous
      final previousStr = item.previous ?? 'null';
      buffer.write(previousStr);

      // Разделитель
      buffer.write(' → ');

      // Третий столбец: current
      buffer.write(item.current ?? 'null');

      buffer.write('\n');
    }

    return buffer.toString();
  }
}