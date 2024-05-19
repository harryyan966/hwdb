import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopupMenuButton(
      tooltip: '',
      offset: const Offset(0, Spacing.xxl),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () => context
                .read<ScoreBoardCubit>()
                .exportScoreBoardToExcel(context),
            child: Text(l10n.buttonLabel_ToExcel),
          ),
          // PopupMenuItem(
          //   onTap: () => context.read<ScoreBoardCubit>().exportScoreBoardToPdf(),
          //   child: Text(l10n.buttonLabel_ToPDF),
          // ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(Spacing.m),
        child: Text(
          l10n.linkLabel_Export,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
