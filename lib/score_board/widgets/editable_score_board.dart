import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';
import 'package:hw_dashboard/score_board/widgets/sort_cell.dart';
import 'package:hw_dashboard/student_score/student_score.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class EditableScoreBoard extends StatefulWidget {
  const EditableScoreBoard({super.key});

  @override
  State<EditableScoreBoard> createState() => _EditableScoreBoardState();
}

class _EditableScoreBoardState extends State<EditableScoreBoard> {
  final _cellInputController = TextEditingController();
  int? editedStudentInd;
  int? editedAssignmentInd;

  @override
  void dispose() {
    _cellInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((ScoreBoardCubit cubit) => cubit.state);
    final assignments = context.select((ScoreBoardCubit cubit) => cubit.state.sortedAssignments);
    final students = context.select((ScoreBoardCubit cubit) => cubit.state.sortedStudents);
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
        legendCell: SortCell(
          onPressed: () {
            context.read<ScoreBoardCubit>().setNameSortScheme();
          },
          activated: state.sortByName,
          reverse: state.reverseSort,
          iconColor: colorScheme.onPrimary,
          child: LegendCell(l10n.scoreBoardLabel_Student),
        ),

        // COLUMNS (ASSIGNMENTS) (AND FINAL SCORE)
        columnsLength: assignments.length + 1,
        columnsTitleBuilder: (index) {
          if (index == assignments.length) {
            return SortCell(
              onPressed: () {
                context.read<ScoreBoardCubit>().setAssignmentSortScheme(null);
              },
              activated: !state.sortByName && state.sortedAssignment == null,
              reverse: state.reverseSort,
              iconColor: colorScheme.onPrimaryContainer,
              child: TitleCell(l10n.scoreBoardLabel_FinalScore, fillColor: colorScheme.primaryContainer),
            );
          }

          final assignment = assignments[index];

          return GestureDetector(
            onTap: () => showAssignmentDetailDialog(context, assignment),
            onSecondaryTapDown: (details) {
              showRightClickMenu(context, details, [
                PopupMenuItem(
                  onTap: () => context.read<ScoreBoardCubit>().deleteAssignment(assignment.id),
                  child: Text(l10n.buttonLabel_Remove),
                ),
              ]);
            },
            child: SortCell(
              onPressed: () {
                context.read<ScoreBoardCubit>().setAssignmentSortScheme(assignment.id);
              },
              activated: !state.sortByName && state.sortedAssignment == assignment.id,
              reverse: state.reverseSort,
              iconColor: colorScheme.onSurface,
              child: TitleCell(assignment.name, fillColor: colorScheme.secondaryContainer),
            ),
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
          // TODO: can we only initialize one of these in the score board
          return GestureDetector(
            onTap: () => _focus(studentInd, assignmentInd),
            child: editedStudentInd == studentInd && editedAssignmentInd == assignmentInd
                ? CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.escape): () {
                        _submitAndUnfocus();
                      },
                      const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
                        _submitAndFocus(studentInd, assignmentInd - 1);
                      },
                      const SingleActivator(LogicalKeyboardKey.arrowRight): () {
                        _submitAndFocus(studentInd, assignmentInd + 1);
                      },
                      const SingleActivator(LogicalKeyboardKey.arrowDown): () {
                        _submitAndFocus(studentInd + 1, assignmentInd);
                      },
                      const SingleActivator(LogicalKeyboardKey.arrowUp): () {
                        _submitAndFocus(studentInd - 1, assignmentInd);
                      }
                    },
                    child: EditedScoreCell(
                      controller: _cellInputController,
                      // SUBMIT THE CURRENT CELL CHANGE AND FOCUS ON THE NEXT CELL
                      onSubmit: (value) {
                        _submitAndUnfocus();
                        _focus(studentInd + 1, assignmentInd);
                      },
                      // SUBMIT THE CURRENT CELL CHANGE ONLY
                      onTapOutside: (_) => _submitAndUnfocus(),
                    ),
                  )
                : ScoreCell(score: state.displayedScore(studentInd, assignmentInd)),
          );
        },
      ),
    );
  }

  void _submitAndFocus(int studentInd, int assignmentInd) {
    // SCORE STRING OF CURRENT STUDENT AND ASSIGNMENT
    final state = context.read<ScoreBoardCubit>().state;
    final scoreString = state.scoreString(studentInd, assignmentInd);

    // IF THE NEW INDEX CANNOT BE FOCUSED ON
    if (!state.canFocus(studentInd, assignmentInd)) {
      _submit();
      return;
    }

    // IF THE INDICES ARE VALID
    _submit();
    setState(() {
      editedStudentInd = studentInd;
      editedAssignmentInd = assignmentInd;

      _cellInputController
        ..text = scoreString
        // SELECT EVERYTHING IN THE CELL
        ..selection = TextSelection(
          baseOffset: 0,
          extentOffset: _cellInputController.text.length,
        );
    });
  }

  // FOCUS ON A CELL
  void _focus(int studentInd, int assignmentInd) {
    // SCORE STRING OF CURRENT STUDENT AND ASSIGNMENT
    final state = context.read<ScoreBoardCubit>().state;
    final scoreString = state.scoreString(studentInd, assignmentInd);

    // IF THE NEW INDEX CANNOT BE FOCUSED ON
    if (!state.canFocus(studentInd, assignmentInd)) {
      return;
    }

    // IF THE INDICES ARE VALID
    else {
      setState(() {
        editedStudentInd = studentInd;
        editedAssignmentInd = assignmentInd;

        _cellInputController
          ..text = scoreString
          // SELECT EVERYTHING IN THE CELL
          ..selection = TextSelection(
            baseOffset: 0,
            extentOffset: _cellInputController.text.length,
          );
      });
    }
  }

  /// Submit changes on a cell and remove focus.
  void _submitAndUnfocus() {
    _submit();

    setState(() {
      editedStudentInd = null;
      editedAssignmentInd = null;
    });
  }

  _submit() {
    final score = double.tryParse(_cellInputController.text);

    context.read<ScoreBoardCubit>().updateScore(editedStudentInd!, editedAssignmentInd!, score);
  }
}
