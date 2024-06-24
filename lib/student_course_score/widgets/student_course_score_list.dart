import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/student_course_score/student_course_score.dart';
import 'package:intl/intl.dart';
import 'package:tools/tools.dart';

class StudentCourseScoreList extends StatelessWidget {
  const StudentCourseScoreList({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = context.select((StudentCourseScoreCubit cubit) => cubit.state.status.isLoading);
    final assignments = context.select((StudentCourseScoreCubit cubit) => cubit.state.assignments);
    final scores = context.select((StudentCourseScoreCubit cubit) => cubit.state.scores);
    final midtermScore = context.select((StudentCourseScoreCubit cubit) => cubit.state.midtermScore);
    final finalScore = context.select((StudentCourseScoreCubit cubit) => cubit.state.finalScore);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return loading
        ? const Center(child: CircularProgressIndicator())
        : assignments.isEmpty
            ? Center(child: Text(l10n.scoreRecordLabel_NoScoresYet))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              LegendCell(l10n.scoreBoardLabel_Assignment),
                              TitleCell(l10n.scoreBoardLabel_AssignmentType, fillColor: colorScheme.secondaryContainer),
                              TitleCell(l10n.scoreBoardLabel_DueDate, fillColor: colorScheme.secondaryContainer),
                              TitleCell(l10n.scoreBoardLabel_Score, fillColor: colorScheme.primaryContainer),
                            ],
                          ),
                          for (final assignment in assignments)
                            TableRow(
                              children: [
                                TitleCell(assignment.name,
                                    fillColor: colorScheme.secondaryContainer, height: Cell.standardHeight),
                                ContentCell(EnumString.assignmentType(context, assignment.type)),
                                ContentCell(DateFormat.yMd().format(assignment.dueDate)),
                                ScoreCell(score: scores[assignment.id]),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.m),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(l10n.scoreboardLabel_UnofficialMidtermScore(
                          midtermScore?.toString() ?? l10n.scoreBoardLabel_EmptyScore)),
                      Text(l10n.scoreboardLabel_UnofficialFinalScore(
                          finalScore?.toString() ?? l10n.scoreBoardLabel_EmptyScore)),
                    ],
                  )
                ],
              );
  }
}
