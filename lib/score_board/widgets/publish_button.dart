import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';

class PublishButton extends StatelessWidget {
  const PublishButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopupMenuButton(
      tooltip: '',
      offset: const Offset(0, Spacing.xxl),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () => context.read<ScoreBoardCubit>().publishAsMidtermScore(),
            child: Text(l10n.buttonLabel_PublishAsMidterm),
          ),
          PopupMenuItem(
            onTap: () => context.read<ScoreBoardCubit>().publishAsFinalScore(),
            child: Text(l10n.buttonLabel_PublishAsFinal),
          ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(Spacing.m),
        child: Text(
          l10n.scoreBoardLabel_Publish,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
