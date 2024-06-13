part of 'score_board_cubit.dart';

@immutable
class ScoreBoardState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, Map<String, double?>> scores;
  final Map<String, double?> finalScores;
  final List<User> students;
  final List<Assignment> assignments;

  const ScoreBoardState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.scores = const {},
    this.finalScores = const {},
    this.students = const [],
    this.assignments = const [],
  });

  /// Students sorted by name.
  List<User> get sortedStudents => students.isEmpty ? [] : students
    ..sort((a, b) => a.name.compareTo(b.name));

  /// Assignments sorted by due date first and name second.
  List<Assignment> get sortedAssignments => assignments.isEmpty ? [] : assignments
    ..sort((a, b) {
      // Return date comparison first and name comparison second.
      final dateComparison = b.dueDate.compareTo(a.dueDate);
      if (dateComparison != 0) return dateComparison;
      return a.name.compareTo(b.name);
    });

  /// Gets student id from student index.
  String? studentId(int studentInd) {
    if (studentInd < 0 || studentInd > students.length) {
      throw Exception('Student index out of bounds.');
    }
    // If concerning average score
    if (studentInd == students.length) {
      return null;
    }
    return sortedStudents[studentInd].id;
  }

  /// Gets assignment id from assignment index.
  String? assignmentId(int assignmentInd) {
    if (assignmentInd < 0 || assignmentInd > assignments.length) {
      throw Exception('Assignment index out of bounds.');
    }
    // If concerning final score
    if (assignmentInd == assignments.length) {
      return null;
    }
    return sortedAssignments[assignmentInd].id;
  }

  /// Gets score from student and assignment index.
  double? displayedScore(int studentInd, int assignmentInd) {
    final sid = studentId(studentInd);
    final aid = assignmentId(assignmentInd);

    // If getting average final score
    if (sid == null && aid == null) {
      final average = ScoreTools.avg(finalScores.values);
      return average == null ? null : ScoreTools.toOneDecimalPlace(average);
    }
    // If getting average score of assignment
    else if (sid == null) {
      final average = ScoreTools.avg([for (final student in students) scores[student.id]?[aid]]);
      return average == null ? null : ScoreTools.toOneDecimalPlace(average);
    }
    // If getting final score of stuent
    else if (aid == null) {
      return finalScores[sid];
    }
    // If getting score of student and assignment
    else {
      return scores[sid]?[aid];
    }
  }

  bool canFocus(int studentInd, int assignmentInd) {
    return studentInd >= 0 && studentInd < students.length && assignmentInd >= 0 && assignmentInd <= assignments.length;
  }

  String scoreString(int studentInd, int assignmentInd) {
    return displayedScore(studentInd, assignmentInd)?.toString() ?? '';
  }

  ScoreBoardState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, Map<String, double?>>? scores,
    Map<String, double?>? finalScores,
    Map<String, double?>? averageScores,
    double? Function()? averageFinalScore,
    List<User>? students,
    List<Assignment>? assignments,
  }) {
    return ScoreBoardState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      scores: scores ?? this.scores,
      finalScores: finalScores ?? this.finalScores,
      students: students ?? this.students,
      assignments: assignments ?? this.assignments,
    );
  }

  @override
  List<Object?> get props => [status, event, error, scores, finalScores, students, assignments];
}
