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

  bool isValidFocus(int studentInd, int assignmentInd) {
    if (studentInd < 0 || studentInd >= students.length) {
      return false;
    }
    if (assignmentInd < 0 || assignmentInd >= assignments.length) {
      return false;
    }
    return true;
  }

  String? studentId(int studentInd) {
    if (studentInd < 0 || studentInd >= students.length) {
      return null;
    }
    return sortedStudents[studentInd].id;
  }

  String? assignmentId(int assignmentInd) {
    if (assignmentInd < 0 || assignmentInd >= assignments.length) {
      return null;
    }
    return sortedAssignments[assignmentInd].id;
  }

  double? score(int studentInd, int assignmentInd) {
    final sid = studentId(studentInd);
    if (sid == null) {
      return null;
    }

    if (assignmentInd == assignments.length) {
      return finalScores[sid];
    }

    final aid = assignmentId(assignmentInd);
    if (aid == null) {
      return null;
    }

    return scores[sid]?[aid];
  }

  String scoreString(int studentInd, int assignmentInd) {
    return score(studentInd, assignmentInd)?.toString() ?? '';
  }

  List<User> get sortedStudents => students.isEmpty ? [] : students
    ..sort((a, b) => a.name.compareTo(b.name));
  List<Assignment> get sortedAssignments => assignments.isEmpty ? [] : assignments
    ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

  ScoreBoardState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, Map<String, double?>>? scores,
    Map<String, double?>? finalScores,
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
  List<Object> get props => [status, event, error, scores, finalScores, students, assignments];
}
