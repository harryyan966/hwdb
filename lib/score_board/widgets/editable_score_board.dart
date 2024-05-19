import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';
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
            onSecondaryTapDown: (details) {
              showRightClickMenu(context, details, [
                PopupMenuItem(
                  onTap: () => context.read<ScoreBoardCubit>().deleteAssignment(assignment.id),
                  child: Text(l10n.buttonLabel_Remove),
                ),
              ]);
            },
            child: TitleCell(assignment.name, fillColor: colorScheme.secondaryContainer),
          );
        },

        // ROWS (STUDENTS)
        rowsLength: students.length,
        rowsTitleBuilder: (index) {
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
                        _submit();
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
                        _submitAndFocus(studentInd + 1, assignmentInd);
                      },
                      // SUBMIT THE CURRENT CELL CHANGE ONLY
                      onTapOutside: (_) => _submit(),
                    ),
                  )
                : ScoreCell(score: state.score(studentInd, assignmentInd)),
          );
        },
      ),
    );
  }

  void _submitAndFocus(int studentInd, int assignmentInd) {
    // SCORE STRING OF CURRENT STUDENT AND ASSIGNMENT
    final scoreString = context.read<ScoreBoardCubit>().state.scoreString(studentInd, assignmentInd);

    // IF THE INDICES ARE OUT OF BOUNDS
    if (scoreString == null) {
      return;
      // setState(() {
      //   editedStudentInd = null;
      //   editedAssignmentInd = null;
      // });
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
    final scoreString = context.read<ScoreBoardCubit>().state.scoreString(studentInd, assignmentInd);

    // IF THE INDICES ARE OUT OF BOUNDS
    if (scoreString == null) {
      return;
      // setState(() {
      //   editedStudentInd = null;
      //   editedAssignmentInd = null;
      // });
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

  // SUBMIT CHANGES ON A CELL
  void _submit() {
    final score = double.tryParse(_cellInputController.text);

    context.read<ScoreBoardCubit>().updateScore(editedStudentInd!, editedAssignmentInd!, score);

    setState(() {
      editedStudentInd = null;
      editedAssignmentInd = null;
    });
  }
}
