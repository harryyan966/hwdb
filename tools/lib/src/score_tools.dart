import 'dart:collection';

import 'package:tools/tools.dart';

class _Assignment {
  final String id;
  final AssignmentType type;
  final DateTime dueDate;

  _Assignment._(this.id, this.type, this.dueDate);

  factory _Assignment.fromJson(Map<String, dynamic> map) {
    return _Assignment._(
      map['id'] as String,
      AssignmentType.values.byName(map['type']),
      DateTime.parse(map['dueDate']),
    );
  }
}

abstract class ScoreTools {
  ScoreTools._();

  /// VALIDATES THE LIST OF ASSIGNMENTS.
  ///
  /// ENSURES THESE ASSIGNMENTS ARE SUFFICIENT TO BE USED TO GENERATE A PUBLISHABLE MIDTERM SCORE.
  ///
  /// TODO: return errors instead of throwing exceptions
  static void validateAssignmentsForMidterm(List<Json> assignments) {
    final assignmentModels = assignments.map((e) => _Assignment.fromJson(e)).toList();

    // ENSURE THERE IS ONE AND ONLY ONE MIDTERM EXAM
    final midtermExams = assignmentModels.where((e) => e.type == AssignmentType.midtermExam);
    if (midtermExams.length != 1) {
      throw Exception('There must be one and only one midterm exam');
    }
    final midtermExam = midtermExams.first;

    // REMOVE ANY ASSIGNMENTS DUE AFTER THE MIDTERM
    assignmentModels.removeWhere((e) => e.dueDate.isAfter(midtermExam.dueDate));

    // ENSURE THERE ARE ENOUGH AMOUNTS OF HOMEWORKS BEFORE THE MIDTERM
    final homeworks = assignmentModels.where((e) => e.type == AssignmentType.homework);

    if (homeworks.length < AssignmentType.homework.countLimit) {
      throw Exception('The amount of homeworks before the midterm is not sufficient');
    }

    // ENSURE THERE ARE ENOUGH AMOUNTS OF QUIZZES BEFORE THE MIDTERM
    final quizzes = assignmentModels.where((e) => e.type == AssignmentType.quiz);

    if (quizzes.length < AssignmentType.quiz.countLimit) {
      throw Exception('The amount of quizzes before the midterm is not sufficient');
    }
  }

  /// Validates the list of assignments.
  ///
  /// Ensures these assignments are sufficient to be used to generate a publishable final score.
  ///
  /// TODO: return errors instead of throwing exceptions
  static void validateAssignmentsForFinal(List<Json> assignments) {
    // Ensure there is one and only one midterm and enough homeworks and quizzes before it.
    validateAssignmentsForMidterm(assignments);

    final assignmentModels = assignments.map((e) => _Assignment.fromJson(e)).toList();

    final midtermExam = assignmentModels.singleWhere((e) => e.type == AssignmentType.midtermExam);

    // Remove any assignments not after the midterm.
    // This implies that the final exam and the participation grade should be given after the midterm.
    assignmentModels.removeWhere((e) => !e.dueDate.isAfter(midtermExam.dueDate));

    // Ensure there is one and only one final exam.
    final finalExams = assignmentModels.where((e) => e.type == AssignmentType.finalExam);
    if (finalExams.length != 1) {
      print('err1');
      throw Exception('There must be one and only one final exam after the midterm');
    }

    // Ensure there is one and only one participation grade.
    final participations = assignmentModels.where((e) => e.type == AssignmentType.participation);
    if (participations.length != 1) {
      print('err2');
      throw Exception('There must be one and only one participation grade after the midterm');
    }

    // Ensure there is a sufficient amount of homeworks after the midterm
    final homeworks = assignmentModels.where((e) => e.type == AssignmentType.homework);
    print(homeworks.map((e) => e.dueDate));

    if (homeworks.length < AssignmentType.homework.countLimit) {
      print('err3');
      throw Exception('The amount of homeworks after the midterm is not sufficient');
    }

    // Ensure there is a sufficient amount of quizzes after the midterm
    final quizzes = assignmentModels.where((e) => e.type == AssignmentType.quiz);

    if (quizzes.length < AssignmentType.quiz.countLimit) {
      print('err4');
      throw Exception('The amount of quizzes after the midterm is not sufficient');
    }
  }

  static Scores computeMidtermScores(List<Json> assignments, MultiScores courseScores) {
    print(assignments.pretty());

    final finalScores = Scores();
    for (final entry in courseScores.entries) {
      final studentId = entry.key;
      final scores = entry.value;
      finalScores[studentId] = computeMidtermScore(assignments, scores);
    }
    return finalScores;
  }

  static Scores computeFinalScores(List<Json> assignments, MultiScores courseScores) {
    print(assignments);
    print(courseScores);

    final finalScores = Scores();
    for (final entry in courseScores.entries) {
      final studentId = entry.key;
      final scores = entry.value;
      finalScores[studentId] = computeFinalScore(assignments, scores);
    }
    return finalScores;
  }

  /// Generates a single midterm score from assignments and scores
  ///
  /// The score is the weighted average of different types of scores (homework, quiz, midterm).
  ///
  /// The following assertions are made
  /// 1. There is at most one midterm
  ///
  /// The assignments may not be valid. The following mitigations are used to generate a score regardless.
  /// 1. If homeworks and quizzes are not enough:
  ///   - the average of the existing homeworks or quizzes will be computed
  ///   - if there is absolutely no homework or quiz, the weight sum will not include the weight of the missing assignment type
  /// 2. If there is no midterm exams:
  ///   - the weight sum will not include the weight of the midterm exam
  ///   - all homeworks and quizzes will all be treated as "before-the-midterm"
  static double? computeMidtermScore(List<Json> assignments, Scores scores) {
    final assignmentModels = assignments
        // Convert json to assignment model.
        .map((e) => _Assignment.fromJson(e))
        // Remove assignments with no scores.
        .where((e) => scores[e.id] != null)
        .toList()
      // Sort assignments by their scores in descending order.
      ..sort((_Assignment a, _Assignment b) {
        return scores[b.id]!.compareTo(scores[a.id]!);
      });

    // Assert that there is at most one midterm.
    assert(assignmentModels.where((e) => e.type == AssignmentType.midtermExam).length <= 1);

    final midtermExam = assignmentModels.where((e) => e.type == AssignmentType.midtermExam).firstOrNull;

    double weightedScoreAverageSum = 0;
    double weightSum = 0;

    // Take the homeworks.
    final homeworks = assignmentModels
        .where((e) =>
            e.type == AssignmentType.homework && (midtermExam == null || !e.dueDate.isAfter(midtermExam.dueDate)))
        .take(AssignmentType.homework.countLimit);

    // Compute score sum and weight sum.
    if (homeworks.isNotEmpty) {
      final scoreAverage = avg(homeworks.map((e) => scores[e.id]!))!;
      weightedScoreAverageSum += scoreAverage * AssignmentType.homework.weight;
      weightSum += AssignmentType.homework.weight;
    }

    // Take the quizzes.
    final quizzes = assignmentModels
        .where((e) => e.type == AssignmentType.quiz && (midtermExam == null || !e.dueDate.isAfter(midtermExam.dueDate)))
        .take(AssignmentType.quiz.countLimit);

    // Compute score sum and weight sum.
    if (quizzes.isNotEmpty) {
      final scoreAverage = avg(quizzes.map((e) => scores[e.id]!))!;
      weightedScoreAverageSum += scoreAverage * AssignmentType.quiz.weight;
      weightSum += AssignmentType.quiz.weight;
    }

    // Compute score sum and weight sum with the midterm.
    if (midtermExam != null) {
      weightedScoreAverageSum += scores[midtermExam.id]! * AssignmentType.midtermExam.weight;
      weightSum += AssignmentType.midtermExam.weight;
    }

    // If there are no assignments
    if (weightSum == 0) {
      return null;
    }

    // Return the score with one decimal precision.
    return double.parse((weightedScoreAverageSum / weightSum).toStringAsFixed(1));
  }

  /// Generates a single final score from assignments and scores
  ///
  /// The score is the weighted average of different types of scores (homework, quiz, midterm, final, participation).
  ///
  /// The following assertions are made
  /// 1. There is at most one of each of these: midterm, final, and participation
  ///
  /// The assignments may not be valid. The following mitigations are used to generate a score regardless.
  /// 1. If homeworks or quizzes are not enough:
  ///   - the average of the existing homeworks or quizzes will be computed
  ///   - if there is absolutely no homework or quiz, the weight sum will not include the weight of the missing assignment type
  /// 2. If there is no midterm exams:
  ///   - the weight sum will not include the weight of the midterm exam
  ///   - all homeworks and quizzes will all be treated as "before-the-midterm"
  ///   - final exam scores will not be accounted
  ///   - participation scores will not be accounted
  /// 3. If there is no final exams:
  ///   - the weight sum will not include the weight of the final exam
  /// 4. If there is no participation grades:
  ///   - the weight sum will not include the weight of the participation grades
  static double? computeFinalScore(List<Json> assignments, Scores scores) {
    final assignmentModels = assignments
        // Convert json to assignment model.
        .map((e) => _Assignment.fromJson(e))
        // Remove assignments with no scores.
        .where((e) => scores[e.id] != null)
        .toList()
      // Sort assignments by their scores in descending order.
      ..sort((_Assignment a, _Assignment b) {
        return scores[b.id]!.compareTo(scores[a.id]!);
      });

    // Assert that there are no duplications of unqiue types.
    assert(assignmentModels.where((e) => e.type == AssignmentType.midtermExam).length <= 1);
    assert(assignmentModels.where((e) => e.type == AssignmentType.finalExam).length <= 1);
    assert(assignmentModels.where((e) => e.type == AssignmentType.participation).length <= 1);

    final midtermExam = assignmentModels.where((e) => e.type == AssignmentType.midtermExam).firstOrNull;

    double weightedScoreAverageSum = 0;
    double weightSum = 0;

    // If there is no midterm exam
    if (midtermExam == null) {
      // Get the homeworks.
      final homeworks =
          assignmentModels.where((e) => e.type == AssignmentType.homework).take(AssignmentType.homework.countLimit);

      // Compute homework score sum and weight sum.
      if (homeworks.isNotEmpty) {
        final scoreAverage = avg(homeworks.map((e) => scores[e.id]!))!;
        weightedScoreAverageSum += scoreAverage * AssignmentType.homework.weight;
        weightSum += AssignmentType.homework.weight;
      }

      // Get the quizzes.
      final quizzes = assignmentModels.where((e) => e.type == AssignmentType.quiz).take(AssignmentType.quiz.countLimit);

      // Compute quiz score sum and weight sum.
      if (quizzes.isNotEmpty) {
        final scoreAverage = avg(quizzes.map((e) => scores[e.id]!))!;
        weightedScoreAverageSum += scoreAverage * AssignmentType.quiz.weight;
        weightSum += AssignmentType.quiz.weight;
      }
    }

    // If there is a midterm exam
    else {
      // Get the homeworks before midterm.
      final homeworksBeforeMidterm = assignmentModels
          .where((e) => e.type == AssignmentType.homework && !e.dueDate.isAfter(midtermExam.dueDate))
          .take(AssignmentType.homework.countLimit);

      // Get the homeworks after midterm.
      final homeworksAfterMidterm = assignmentModels
          .where((e) => e.type == AssignmentType.homework && e.dueDate.isAfter(midtermExam.dueDate))
          .take(AssignmentType.homework.countLimit);

      // Get all homeworks.
      final homeworks = [...homeworksBeforeMidterm, ...homeworksAfterMidterm];

      // Compute homework score sum and weight sum.
      if (homeworks.isNotEmpty) {
        final scoreAverage = avg(homeworks.map((e) => scores[e.id]!))!;
        weightedScoreAverageSum += scoreAverage * AssignmentType.homework.weight;
        weightSum += AssignmentType.homework.weight;
      }

      // Get the quizzes before midterm.
      final quizzesBeforeMidterm = assignmentModels
          .where((e) => e.type == AssignmentType.quiz && !e.dueDate.isAfter(midtermExam.dueDate))
          .take(AssignmentType.quiz.countLimit);

      // Get the quizzes after midterm.
      final quizzesAfterMidterm = assignmentModels
          .where((e) => e.type == AssignmentType.quiz && e.dueDate.isAfter(midtermExam.dueDate))
          .take(AssignmentType.quiz.countLimit);

      // Get all quizzes.
      final quizzes = [...quizzesBeforeMidterm, ...quizzesAfterMidterm];

      // Compute quiz score sum and weight sum.
      if (quizzes.isNotEmpty) {
        final scoreAverage = avg(quizzes.map((e) => scores[e.id]!))!;
        weightedScoreAverageSum += scoreAverage * AssignmentType.quiz.weight;
        weightSum += AssignmentType.quiz.weight;
      }

      // Compute midterm score sum and weight sum.
      weightedScoreAverageSum += scores[midtermExam.id]! * AssignmentType.midtermExam.weight;
      weightSum += AssignmentType.midtermExam.weight;
    }

    // Get the final exam and compute final exam score sum and weight sum.
    final finalExam = assignmentModels.where((e) => e.type == AssignmentType.finalExam).firstOrNull;
    if (finalExam != null) {
      weightedScoreAverageSum += scores[finalExam.id]! * AssignmentType.finalExam.weight;
      weightSum += AssignmentType.finalExam.weight;
    }

    // Get the participation grade and compute participation score sum and weight sum.
    final participation = assignmentModels.where((e) => e.type == AssignmentType.participation).firstOrNull;
    if (participation != null) {
      weightedScoreAverageSum += scores[participation.id]! * AssignmentType.participation.weight;
      weightSum += AssignmentType.participation.weight;
    }

    // If there are no weights (there are no assignments)
    if (weightSum == 0) {
      return null;
    }

    // Return the score with one decimal precision.
    return toOneDecimalPlace(weightedScoreAverageSum / weightSum);
  }

  static double toOneDecimalPlace(double val) {
    return double.parse(val.toStringAsFixed(1));
  }

  static double? avg(Iterable<double?> arr) {
    final arrWithoutNull = arr.where((e) => e != null);
    if (arrWithoutNull.isEmpty) {
      return null;
    }
    return arrWithoutNull.fold(0.0, (p, c) => p + c!) / arrWithoutNull.length;
  }
}
