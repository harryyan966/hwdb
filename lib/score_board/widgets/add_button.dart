import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_assignment/create_assignment.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopupMenuButton(
      tooltip: '',
      offset: const Offset(0, Spacing.xxl),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () => context.nav
                .push(CreateAssignmentPage.route(courseInfo: context.read<ScoreBoardCubit>().courseInfo))
                .then((assignment) {
              if (assignment != null) {
                context.read<ScoreBoardCubit>().addAssignment(assignment);
              }
            }),
            child: Text(l10n.scoreBoardLabel_Assignment),
          ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(Spacing.m),
        child: Text(
          l10n.linkLabel_Add,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
