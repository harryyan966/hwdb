part of 'student_score_report_cubit.dart';

@immutable
class StudentScoreReportState extends Equatable {
  final PageStatus status;
  final List<ScoreRecord> scoreRecords;

  const StudentScoreReportState({
    this.status = PageStatus.good,
    this.scoreRecords = const [],
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
