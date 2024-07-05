part of 'score_board_cubit.dart';

@immutable
class ScoreBoardState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, Map<String, double?>> scores;
  final Map<String, double?> finalScores;
  final bool sortByName;
  final String? sortedAssignment;
  final bool reverseSort;
  final List<User> students;
  final List<Assignment> assignments;

  const ScoreBoardState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.scores = const {},
    this.finalScores = const {},
    this.sortByName = true,
    this.sortedAssignment,
    this.reverseSort = false,
    this.students = const [],
    this.assignments = const [],
  });

  /// Students sorted according to the rules provided (name, assignment, reverse).
  List<User> get sortedStudents {
    if (students.isEmpty) {
      return []; // When the list is initialized, it is const and cannot be sorted.
    }

    // Sort students by name.
    // TODO: will this sorting preference remain after another sort (perhaps by score)?
    students.sort((a, b) => a.name.compareTo(b.name));

    // If students are sorted by name
    if (sortByName) {
      // Sort by name only.
      return reverseSort ? students.reversed.toList() : students;
    }
    // If students are sorted by score
    else {
      // If the user provided an assignment to sort on
      if (sortedAssignment != null) {
        // If the assignment exists
        if (assignments.any((e) => e.id == sortedAssignment)) {
          // Sort by scores of this assignment.
          return students
            ..sort((a, b) {
              final scoreA = scores[a.id]?[sortedAssignment] ?? -1;
              final scoreB = scores[b.id]?[sortedAssignment] ?? -1;
              return reverseSort ? scoreB.compareTo(scoreA) : scoreA.compareTo(scoreB);
            });
        }
        // If the assignment does not exist
        else {
          // Sort by name only.
          return reverseSort ? students.reversed.toList() : students;
        }
      }
      // If the user did not provide an assignment to sort on
      else {
        // Sort by final score.
        return students
          ..sort((a, b) {
            final scoreA = finalScores[a.id] ?? -1;
            final scoreB = finalScores[b.id] ?? -1;
            return reverseSort ? scoreB.compareTo(scoreA) : scoreA.compareTo(scoreB);
          });
      }
    }
  }

  /// Assignments sorted by due date then type then name.
  List<Assignment> get sortedAssignments => assignments.isEmpty ? [] : assignments
    ..sort((a, b) {
      // Sort by date.
      final dateComparison = b.dueDate.compareTo(a.dueDate);
      if (dateComparison != 0) {
        return dateComparison;
      }
      // Sort by assignment type.
      final typeComparison = b.type.index.compareTo(a.type.index);
      if (typeComparison != 0) {
        return typeComparison;
      }
      // Sort by assignment name.
      return b.name.compareTo(a.name);
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
    bool? sortByName,
    String? Function()? sortedAssignment,
    bool? reverseSort,
    List<User>? students,
    List<Assignment>? assignments,
  }) {
    return ScoreBoardState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      scores: scores ?? this.scores,
      finalScores: finalScores ?? this.finalScores,
      sortByName: sortByName ?? this.sortByName,
      sortedAssignment: sortedAssignment == null ? this.sortedAssignment : sortedAssignment(),
      reverseSort: reverseSort ?? this.reverseSort,
      students: students ?? this.students,
      assignments: assignments ?? this.assignments,
    );
  }

  @override
  List<Object?> get props =>
      [status, event, error, scores, finalScores, sortByName, sortedAssignment, reverseSort, students, assignments];
}
