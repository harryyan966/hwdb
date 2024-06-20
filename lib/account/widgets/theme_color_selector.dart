import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class ThemeColorSelector extends StatelessWidget {
  const ThemeColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeColor = context.select((AppCubit cubit) => cubit.state.themeColor);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.m),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LABEL TEXT
          Text(l10n.formLabel_SelectThemeColor),
          const SizedBox(width: Spacing.l),

          // THEME COLOR SELECTOR
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(l10n.formLabel_SelectThemeColor),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: themeColor,
                    onColorChanged: context.read<AppCubit>().setThemeColor,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text(l10n.buttonLabel_Select),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            child: Text(l10n.buttonLabel_Select),
          ),
        ],
      ),
    );
  }
}
