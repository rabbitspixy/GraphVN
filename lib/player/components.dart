import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class ChangedVariableRow {
  final String keyColumn;
  final String valueColumn;
  final bool isChanged;

  ChangedVariableRow({
    required this.keyColumn,
    required this.valueColumn,
    required this.isChanged,
  });
}

class VariablesDiffDebug {
  final Map<String, String> previous;
  final Map<String, String> current;

  VariablesDiffDebug({
    required this.previous,
    required this.current,
  });

  List<VariablePreviousCurrentValue> getVariables() {
    final List<VariablePreviousCurrentValue> result = [];
    final allKeys = {...previous.keys, ...current.keys};

    for (final key in allKeys) {
      final previousValue = previous[key];
      final currentValue = current[key];

      result.add(
        VariablePreviousCurrentValue(
          key: key,
          previous: previousValue,
          current: currentValue,
        ),
      );
    }

    result.sort((a, b) => a.key.compareTo(b.key));
    return result;
  }

  List<ChangedVariableRow> _getChangedVariablesRows() {
    final variables = getVariables();

    if (variables.isEmpty) {
      return [];
    }

    final rows = <ChangedVariableRow>[];
    for (final item in variables) {
      final previousStr = item.previous ?? 'null';
      final currentStr = item.current ?? 'null';
      final isChanged = previousStr != currentStr;

      final valueColumn = isChanged ? "$previousStr -> $currentStr" : currentStr;

      rows.add(
        ChangedVariableRow(
          keyColumn: item.key,
          valueColumn: valueColumn,
          isChanged: isChanged,
        ),
      );
    }

    return rows;
  }

  TextSpan _buildTextSpanFromRows(List<ChangedVariableRow> rows) {
    if (rows.isEmpty) {
      return const TextSpan(text: '');
    }

    int maxKeyLength = 0;
    int maxValueLength = 0;
    for (final row in rows) {
      maxKeyLength = row.keyColumn.length > maxKeyLength ? row.keyColumn.length : maxKeyLength;
      maxValueLength = row.valueColumn.length > maxValueLength ? row.valueColumn.length : maxValueLength;
    }

    final changedFontStyle = TextStyle(
      color: const Color(0xFF87CEFA),
      fontSize: 12,
      fontFamily: GoogleFonts.robotoMono().fontFamily,
    );

    final notChangedFontStyle = TextStyle(
      color: Colors.grey,
      fontSize: 12,
      fontFamily: GoogleFonts.robotoMono().fontFamily,
    );

    final spans = <TextSpan>[];
    for (final row in rows) {
      final lineSpans = <TextSpan>[];

      // Цвет строки: светло-синий для измененных, серый для остальных
      final fontStyle = row.isChanged ? changedFontStyle : notChangedFontStyle;

      // Первый столбец: key
      final padding1 = ' ' * (maxKeyLength - row.keyColumn.length + 3);
      lineSpans.add(TextSpan(text: row.keyColumn + padding1, style: fontStyle));

      // Второй столбец: valueColumn
      final padding2 = ' ' * (maxValueLength - row.valueColumn.length);
      lineSpans.add(TextSpan(text: padding2 + row.valueColumn, style: fontStyle));

      // Добавляем перевод строки
      lineSpans.add(const TextSpan(text: '\n'));

      spans.addAll(lineSpans);
    }

    return TextSpan(children: spans);
  }

  TextSpan getChangedVariablesTableText() {
    final rows = _getChangedVariablesRows();
    return _buildTextSpanFromRows(rows);
  }
}