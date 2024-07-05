import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Cell extends StatelessWidget {
  const Cell._({
    required this.width,
    required this.height,
    required this.child,
    this.background,
  });

  static const double standardWidth = 128;
  static const double standardHeight = 48;

  final double width;
  final double height;
  final Color? background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background,
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
      ),
      child: Center(child: child),
    );
  }
}

class LegendCell extends StatelessWidget {
  const LegendCell(
    this.title, {
    this.width = LegendCell.standardWidth,
    this.height = LegendCell.standardHeight,
    super.key,
  });
  final String title;

  static const double standardWidth = 240;
  static const double standardHeight = 64;

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Cell._(
      width: width,
      height: height,
      background: colorScheme.primary,
      child: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class TitleCell extends StatelessWidget {
  const TitleCell(
    this.title, {
    this.fillColor,
    this.width = LegendCell.standardWidth,
    this.height = LegendCell.standardHeight,
    this.textColor,
    super.key,
  });
  final String title;
  final double width;
  final double height;
  final Color? fillColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Cell._(
      width: width,
      height: height,
      background: fillColor,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.s),
        child: Tooltip(
          message: title,
          child: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: textColor,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ContentCell extends StatelessWidget {
  const ContentCell(
    this.content, {
    this.width = Cell.standardWidth,
    this.height = Cell.standardHeight,
    super.key,
  });

  final String content;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Cell._(
      width: width,
      height: height,
      child: Text(content, style: textTheme.bodyMedium),
    );
  }
}

class ScoreCell extends StatelessWidget {
  const ScoreCell({
    required this.score,
    this.width = Cell.standardWidth,
    this.height = Cell.standardHeight,
    super.key,
  });

  final double? score;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Cell._(
      width: width,
      height: height,
      background: score == null ? colorScheme.error : null,
      child: Text(
        // TODO: how to get l10n in here? l10n.label_Empty
        score?.toString() ?? 'NOTHING!',
        style: textTheme.bodyMedium?.copyWith(
          color: score == null ? colorScheme.onError : null,
          fontWeight: score == null ? FontWeight.bold : null,
        ),
      ),
    );
  }
}

class EditedScoreCell extends StatelessWidget {
  const EditedScoreCell({
    required this.controller,
    required this.onSubmit,
    required this.onTapOutside,
    this.width = Cell.standardWidth,
    this.height = Cell.standardHeight,
    super.key,
  });

  final TextEditingController controller;
  final void Function(String value) onSubmit;
  final void Function(PointerDownEvent event) onTapOutside;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Cell._(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        // TODO: will this cause memory leaks?
        focusNode: FocusNode()..requestFocus(),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
        ),
        inputFormatters: [ScoreTextInputFormatter()],
        style: textTheme.bodyMedium,
        onSubmitted: onSubmit,
        onTapOutside: onTapOutside,
      ),
    );
  }
}

// ALLOWS SOME AND DISALLOWS OTHER INPUT IN THE CELL TEXT FIELDS
class ScoreTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // ALLOW EMPTY VALUES
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // ALLOW {ZERO TO THREE NUMBERS} + {ONE OR ZERO DOTS} + {ONE OR ZERO NUMBERS} ONLY
    final match = RegExp(r'^\d{0,3}\.?\d{0,1}$').allMatches(newValue.text).firstOrNull;
    if (match == null) {
      return oldValue;
    }

    // ALLOW DOUBLES ONLY
    final newScore = double.tryParse(newValue.text);
    if (newScore == null) {
      return oldValue;
    }

    // ALLOW SCORES FROM 0 TO 100 ONLY
    if (newScore > 100 || newScore < 0) {
      return oldValue;
    }

    return newValue;
  }
}
