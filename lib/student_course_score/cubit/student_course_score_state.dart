part of 'student_course_score_cubit.dart';

@immutable
class StudentCourseScoreState extends Equatable {
  final PageStatus status;
  final List<Assignment> assignments;
  final Map<String, double?> scores;
  final double? midtermScore;
  final double? finalScore;

  const StudentCourseScoreState({
    this.status = PageStatus.good,
    this.assignments = const [],
    this.scores = const {},
    this.midtermScore,
    this.finalScore,
  });

  List<Assignment> get sortedAssignments => assignments.isEmpty ? [] : assignments
    ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

  StudentCourseScoreState copyWith({
    PageStatus? status,
    List<Assignment>? assignments,
    Map<String, double?>? scores,
    double? Function()? midtermScore,
    double? Function()? finalScore,
  }) {
    return StudentCourseScoreState(
      status: status ?? this.status,
      assignments: assignments ?? this.assignments,
      scores: scores ?? this.scores,
      midtermScore: midtermScore == null ? this.midtermScore : midtermScore(),
      finalScore: finalScore == null ? this.finalScore : finalScore(),
    );
  }

  @override
  List<Object?> get props => [status, assignments, scores, midtermScore, finalScore];
}
