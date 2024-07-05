part of 'student_score_report_cubit.dart';

@immutable
class StudentScoreReportState extends Equatable {
  final PageStatus status;
  final List<ScoreRecord> scoreRecords;

  const StudentScoreReportState({
    this.status = PageStatus.good,
    this.scoreRecords = const [],
  });

  /// Score records sorted in ascending order by grade then type.
  List<ScoreRecord> get sortedScoreRecords => scoreRecords
    ..sort((a, b) {
      final gradeComparison = a.course.grade.index.compareTo(b.course.grade.index);
      if (gradeComparison != 0) {
        return gradeComparison;
      }
      return a.type.index.compareTo(b.type.index);
    });

  StudentScoreReportState copyWith({
    PageStatus? status,
    List<ScoreRecord>? scoreRecords,
  }) {
    return StudentScoreReportState(
      status: status ?? this.status,
      scoreRecords: scoreRecords ?? this.scoreRecords,
    );
  }

  @override
  List<Object> get props => [status, scoreRecords];
}
