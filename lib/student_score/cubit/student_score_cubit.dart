import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'student_score_state.dart';

class StudentScoreCubit extends Cubit<StudentScoreState> {
  StudentScoreCubit({
    required HwdbHttpClient httpClient,
    required this.courseInfo,
    required this.student,
  })  : _httpClient = httpClient,
        super(const StudentScoreState());

  final HwdbHttpClient _httpClient;
  final CourseInfo courseInfo;
  final User student;

  Future<void> getScores() async {
    // DO NOTHING IF THE PAGE IS LOADING
    if (state.status.isLoading) {
      return;
    }

    // START LOADING THE PAGE
    emit(state.copyWith(status: PageStatus.loading));

    // GET THE STUDENT SCORE
    final res = await _httpClient.get('courses/${courseInfo.id}/scores/student/${student.id}');

    // IF THE SERVER RETURNED THE SCORE LIST
    if (Events.gotStudentCourseScore.matches(res['event'])) {
      final assignments = ConversionTools.toJsonTypeList(res['data']['assignments'], Assignment.fromJson);
      final scores = ConversionTools.toScores(res['data']['scores']);
      final midtermScore = ScoreTools.computeMidtermScore(assignments.map((e) => e.toJson()).toList(), scores);
      final finalScore = ScoreTools.computeFinalScore(assignments.map((e) => e.toJson()).toList(), scores);

      emit(state.copyWith(
        status: PageStatus.good,
        assignments: assignments.toList(),
        scores: scores,
        midtermScore: () => midtermScore,
        finalScore: () => finalScore,
      ));
    }

    // THROW ANY UNEXPECTED RESPONSE
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
