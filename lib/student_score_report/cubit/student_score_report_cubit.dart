import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'student_score_report_state.dart';

class StudentScoreReportCubit extends Cubit<StudentScoreReportState> {
  StudentScoreReportCubit({
    required HwdbHttpClient httpClient,
    required this.student,
  })  : _httpClient = httpClient,
        super(const StudentScoreReportState());

  final HwdbHttpClient _httpClient;
  final User student;

  Future<void> getScoreReport() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // GET SCORE REPORT FROM API
    final res = await _httpClient.get('scorereports/student/${student.id}');

    // IF THE SCORE REPORT IS RETURNED
    if (Events.gotStudentScoreReport.matches(res['event'])) {
      final List<ScoreRecord> scoreRecords = ConversionTools.toJsonTypeList(res['data'], ScoreRecord.fromJson);

      emit(state.copyWith(
        status: PageStatus.good,
        scoreRecords: scoreRecords,
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
