import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';
import 'package:hw_dashboard/student_score/student_score.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ReadOnlyScoreBoard extends StatefulWidget {
  const ReadOnlyScoreBoard({super.key});

  @override
  State<ReadOnlyScoreBoard> createState() => _ReadOnlyScoreBoardState();
}

class _ReadOnlyScoreBoardState extends State<ReadOnlyScoreBoard> {
  @override
  Widget build(BuildContext context) {
    final state = context.select((ScoreBoardCubit cubit) => cubit.state);
    final assignments = state.sortedAssignments;
    final students = state.sortedStudents;
    final course = context.read<ScoreBoardCubit>().courseInfo;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(Spacing.l),
      child: StickyHeadersTable(
        // AESTHETICS SETTINGS
        cellDimensions: const CellDimensions.fixed(
          contentCellWidth: Cell.standardWidth,
          contentCellHeight: Cell.standardHeight,
          stickyLegendWidth: LegendCell.standardWidth,
          stickyLegendHeight: LegendCell.standardHeight,
        ),
        cellAlignments: const CellAlignments.uniform(Alignment.center),

        // TOP LEFT CELL (LEGEND CELL)
        legendCell: LegendCell(l10n.scoreBoardLabel_Student),

        // COLUMNS (ASSIGNMENTS) (AND FINAL SCORE)
        columnsLength: assignments.length + 1,
        columnsTitleBuilder: (index) {
          if (index == assignments.length) {
            return TitleCell(l10n.scoreBoardLabel_FinalScore, fillColor: colorScheme.primaryContainer);
          }

          final assignment = assignments[index];

          return GestureDetector(
            onTap: () => showAssignmentDetailDialog(context, assignment),
            child: TitleCell(assignment.name, fillColor: colorScheme.secondaryContainer),
          );
        },

        // ROWS (STUDENTS)
        rowsLength: students.length + 1,
        rowsTitleBuilder: (index) {
          if (index == students.length) {
            return TitleCell(l10n.scoreBoardLabel_AverageScore, fillColor: colorScheme.primaryContainer);
          }

          final student = students[index];

          return GestureDetector(
            onTap: () => context.nav.push(StudentScorePage.route(course, student)),
            child: TitleCell(student.name, fillColor: colorScheme.secondaryContainer),
          );
        },

        // SCORE
        contentCellBuilder: (assignmentInd, studentInd) {
          return ScoreCell(score: state.displayedScore(studentInd, assignmentInd));
        },
      ),
    );
  }
}
