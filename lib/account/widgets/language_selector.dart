import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = context.select((AppCubit cubit) => cubit.state.language);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // LABEL TEXT
        Text(l10n.formLabel_SelectLangauge),
        const SizedBox(width: Spacing.l),

        // LANGUAGE SELECTOR
        DropdownButton(
          focusColor: Colors.transparent,
          value: language,
          items: const [
            DropdownMenuItem(value: Language.en, child: Text('English')),
            DropdownMenuItem(value: Language.zh, child: Text('中文')),
          ],
          onChanged: (value) => context.read<AppCubit>().setLanguage(value!),
        ),
      ],
    );
  }
}
