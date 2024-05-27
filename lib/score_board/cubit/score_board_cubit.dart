import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:excel/excel.dart' as ex;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

part 'score_board_state.dart';

class ScoreBoardCubit extends Cubit<ScoreBoardState> {
  ScoreBoardCubit({
    required HwdbHttpClient httpClient,
    required this.courseInfo,
  })  : _httpClient = httpClient,
        super(const ScoreBoardState());

  final HwdbHttpClient _httpClient;
  final CourseInfo courseInfo;

  /// Gets the scoreboard from the server, including assignments, students, scores, and final scores.
  Future<void> getScoreBoard() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Get the scoreboard.
    final res = await _httpClient.get('courses/${courseInfo.id}/scores');

    // If the server returned the scoreboard
    if (Events.gotScoreboard.matches(res['event'])) {
      final List<Assignment> assignments =
          ConversionTools.toJsonTypeList(res['data']['assignments'], Assignment.fromJson);
      final List<User> students = ConversionTools.toJsonTypeList(res['data']['students'], User.fromJson);
      final MultiScores scores = ConversionTools.toMultiScores(res['data']['scores']);
      final Scores finalScores = ConversionTools.toScores(res['data']['finalScores']);

      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.gotScoreboard,
        assignments: assignments,
        students: students,
        scores: scores,
        finalScores: finalScores,
      ));
    }
  }

  /// Updates a score by student and assignment indices.
  Future<void> updateScore(int studentInd, int assignmentInd, double? score) async {
    // If the score is not changed
    if (state.score(studentInd, assignmentInd) == score) {
      return;
    }

    // If the user is updating a final score
    if (assignmentInd == state.assignments.length) {
      await _updateFinalScore(state.studentId(studentInd)!, score);
    }

    // If the user is updating a normal score
    else {
      await _updateScore(
        state.studentId(studentInd)!,
        state.assignmentId(assignmentInd)!,
        score,
      );
    }
  }

  /// Updates the final score of a student.
  Future<void> _updateFinalScore(String studentId, double? score) async {
    if (state.status.isLoading) return;
    // Don't start loading during `_updateFinalScore` as it will slow down performance.

    // Update local data optimistically.
    state.finalScores[studentId] = score;

    // Send the request to the api.
    final res = await _httpClient.patch('courses/${courseInfo.id}/scores/student/$studentId/final', args: {
      'score': score,
    });

    // If the api has updated the final score.
    if (Events.updatedCourseFinalScore.matches(res['event'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.updatedCourseFinalScore,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Updates a normal score of a student.
  Future<void> _updateScore(String studentId, String assignmentId, double? score) async {
    if (state.status.isLoading) return;
    // Don't start loading during `_updateScore` as it will slow down performance.

    // Update local data optimistically.
    if (state.scores[studentId] == null) {
      state.scores[studentId] = {};
    }
    state.scores[studentId]![assignmentId] = score;

    // Send the request to the api.
    final res = await _httpClient.patch('courses/${courseInfo.id}/scores/student/$studentId', args: {
      'assignmentId': assignmentId,
      'score': score,
    });

    // If the api has updated the score
    if (Events.updatedCourseScore.matches(res['event'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.updatedCourseScore,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Adds an assignment locally.
  void addAssignment(Assignment assignment) {
    emit(state.copyWith(assignments: [...state.assignments, assignment]));
  }

  /// Updates the student list locally.
  void updateStudentList(List<User> students) {
    emit(state.copyWith(students: students));
  }

  // TODO: should we use savescores or update scores: CHECK ON LATENCY, deprecating saveScores temporarily
  /// Saves every score in the scoreboard.
  @Deprecated('Use save score instead.')
  Future<void> saveScores() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // REQUEST TO SAVE SCORES
    final res = await _httpClient.put('courses/${courseInfo.id}/scores', args: {
      'scores': state.scores,
    });

    // IF THE SCORES ARE SUCCESSFULLY SAVED
    if (Events.updatedCourseScores.matches(res['event'])) {
      emit(state.copyWith(status: PageStatus.good, event: Events.updatedCourseScores));
    }

    // THROW ANY UNEXPECTED RESPONSE
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Deletes assignment from database.
  Future<void> deleteAssignment(String assignmentId) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Send the request to the api.
    final res = await _httpClient.delete('courses/${courseInfo.id}/assignments/$assignmentId');

    // If the api has removed the assignment
    if (Events.deletedAssignment.matches(res['event'])) {
      // Update the assignments locally.
      final assignments = state.assignments.where((e) => e.id != assignmentId).toList();

      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.deletedAssignment,
        assignments: assignments,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Calculates and updates final score for all students in the course.
  Future<void> generateFinalScores() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Send the request to the api.
    final res = await _httpClient.put('courses/${courseInfo.id}/scores/final');

    // If the api has calculated the final scores.
    if (Events.generatedFinalScore.matches(res['event'])) {
      final finalScores = ConversionTools.toScores(res['data']);

      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.generatedFinalScore,
        finalScores: finalScores,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Calculates and updates final score for all students in the course.
  Future<void> generateMidtermScores() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Send the request to the api.
    final res = await _httpClient.put('courses/${courseInfo.id}/scores/midterm');

    // If the api has calculated the midterm scores.
    if (Events.generatedMidtermScore.matches(res['event'])) {
      final midtermScores = ConversionTools.toScores(res['data']);

      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.generatedFinalScore,
        finalScores: midtermScores,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Saves the current `finalScore` to the midterm score report.
  Future<void> publishAsMidtermScore() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Ensure the course has a sufficient assignment list.
    try {
      ScoreTools.validateAssignmentsForMidterm(state.assignments.map((e) => e.toJson()).toList());
    } on Exception {
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.insufficientAssignmentList,
      ));
      return;
    }

    // Send the request to the api.
    final res = await _httpClient.post('/courses/${courseInfo.id}/scores/midterm');

    // If the api has published the scores.
    if (Events.publishedMidtermScore.matches(res['event'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.publishedMidtermScore,
      ));
    }

    // If the amount of assignments is not sufficient
    else if (Errors.insufficientAssignmentList.matches(res['error'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        error: Errors.insufficientAssignmentList,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Saves the current `finalScore` to the final score report.
  Future<void> publishAsFinalScore() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Ensure the course has a sufficient assignment list.
    try {
      ScoreTools.validateAssignmentsForFinal(state.assignments.map((e) => e.toJson()).toList());
    } on Exception {
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.insufficientAssignmentList,
      ));
      return;
    }

    // Send the request to the api.
    final res = await _httpClient.post('/courses/${courseInfo.id}/scores/final');

    // If the api has published the scores.
    if (Events.publishedFinalScore.matches(res['event'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.publishedFinalScore,
      ));
    }

    // If the amount of assignments is not sufficient
    else if (Errors.insufficientAssignmentList.matches(res['error'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        error: Errors.insufficientAssignmentList,
      ));
    }

    // Ensure no other types of responses are returned.
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Saves an excel sheet representation of this scoreboard.
  Future<void> exportScoreBoardToExcel(BuildContext context) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    // INITIALIZE EXCEL SHEET
    final excel = ex.Excel.createExcel();
    final sheet = excel[l10n.scoreBoardLabel_Score];

    // DEFINE CELL STYLE
    final baseStyle = ex.CellStyle(
      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
      horizontalAlign: ex.HorizontalAlign.Center,
      verticalAlign: ex.VerticalAlign.Center,
      textWrapping: ex.TextWrapping.WrapText,
      backgroundColorHex: ex.ExcelColor.fromInt(colorScheme.surface.value),
      fontColorHex: ex.ExcelColor.fromInt(colorScheme.onSurface.value),
      bottomBorder: ex.Border(
          borderStyle: ex.BorderStyle.Thin, borderColorHex: ex.ExcelColor.fromInt(colorScheme.onSurface.value)),
    );

    // INSERT LEGEND CELL
    final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = ex.TextCellValue(l10n.scoreBoardLabel_Student);
    cell.cellStyle = baseStyle.copyWith(
      boldVal: true,
      backgroundColorHexVal: ex.ExcelColor.fromInt(colorScheme.primary.value),
      fontColorHexVal: ex.ExcelColor.fromInt(colorScheme.onPrimary.value),
    );

    sheet.setRowHeight(0, 30);
    sheet.setColumnWidth(0, 20);

    // INSERT STUDENTS IN ROW TITLES
    for (int i = 0; i < state.sortedStudents.length; i++) {
      final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1));
      cell.value = ex.TextCellValue(state.sortedStudents[i].name);
      cell.cellStyle = baseStyle.copyWith(
        boldVal: true,
        backgroundColorHexVal: ex.ExcelColor.fromInt(colorScheme.secondaryContainer.value),
        fontColorHexVal: ex.ExcelColor.fromInt(colorScheme.onSecondaryContainer.value),
      );

      sheet.setRowHeight(i + 1, 30);
    }

    // INSERT ASSIGNMENTS AND "FINAL SCORES" IN COLUMN TITLES
    for (int i = 0; i < state.sortedAssignments.length + 1; i++) {
      final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: i + 1, rowIndex: 0));
      cell.value = i == state.assignments.length
          ? ex.TextCellValue(l10n.scoreBoardLabel_FinalScore) // "FINAL SCORE"
          : ex.TextCellValue(state.sortedAssignments[i].name); // ASSIGNMENT
      cell.cellStyle = baseStyle.copyWith(
        boldVal: true,
        backgroundColorHexVal: i == state.assignments.length
            ? ex.ExcelColor.fromInt(colorScheme.primaryContainer.value)
            : ex.ExcelColor.fromInt(colorScheme.secondaryContainer.value),
        fontColorHexVal: i == state.assignments.length
            ? ex.ExcelColor.fromInt(colorScheme.onPrimaryContainer.value)
            : ex.ExcelColor.fromInt(colorScheme.onSecondaryContainer.value),
      );

      sheet.setColumnWidth(i + 1, 15);
    }

    // INSERT SCORES IN CONTENT
    for (int i = 0; i < state.sortedStudents.length; i++) {
      for (int j = 0; j < state.sortedAssignments.length + 1; j++) {
        // ASSIGNMENT AND FINAL SCORES
        final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: j + 1, rowIndex: i + 1));
        final score = state.score(i, j);
        cell.value = score == null ? ex.TextCellValue(l10n.scoreBoardLabel_EmptyScore) : ex.DoubleCellValue(score);
        cell.cellStyle = baseStyle.copyWith(
          backgroundColorHexVal: score == null ? ex.ExcelColor.fromInt(colorScheme.errorContainer.value) : null,
          fontColorHexVal: score == null ? ex.ExcelColor.fromInt(colorScheme.onErrorContainer.value) : null,
        );
      }
    }

    // DELETE DEFAULT SHEET
    final defaultSheetName = excel.getDefaultSheet();
    if (defaultSheetName != null) excel.delete(defaultSheetName);

    // THE FILE NAME WILL BE COURSE NAME (WITH ALL INVALID CHARACTERS REMOVED) + .XLSX EXTENSION
    final fileName = '${courseInfo.name.replaceAll(RegExp(r'/|\\|:|\*|\?|<|>|\|'), '')}.xlsx';
    final fileBytes = excel.encode()! as Uint8List;

    try {
      // SAVE THE FILE TO THE DOWNLOAD FOLDER
      await FileSaver.instance.saveFile(name: fileName, bytes: fileBytes);

      emit(state.copyWith(status: PageStatus.good, event: Events.savedExcel));
    }

    // THE EXCEL FILE IS ALREADY OPENED OR CANNOT BE ACCESSED
    on PathAccessException {
      emit(state.copyWith(status: PageStatus.bad, error: Errors.cannotSaveExcel));
    }
  }

  Future<void> exportScoreBoardToPdf() async {
    // TODO: IMPLEMENT EXPORTING TO PDF
    // throw UnimplementedError();
  }
}
