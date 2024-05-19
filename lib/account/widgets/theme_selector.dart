import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeMode = context.select((AppCubit cubit) => cubit.state.themeMode);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // LABEL TEXT
        Text(l10n.formLabel_SelectTheme),
        const SizedBox(width: Spacing.l),

        // THEME SELECTOR
        DropdownButton(
          focusColor: Colors.transparent,
          value: themeMode,
          items: [
            DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.formOption_SystemTheme)),
            DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.formOption_LightTheme)),
            DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.formOption_DarkTheme)),
          ],
          onChanged: (value) => context.read<AppCubit>().setTheme(value!),
        ),
      ],
    );
  }
}
