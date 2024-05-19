import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'select_course_teacher_state.dart';

class SelectCourseTeacherCubit extends Cubit<SelectCourseTeacherState> {
  SelectCourseTeacherCubit({
    required HwdbHttpClient httpClient,
    required this.courseInfo,
  })  : _httpClient = httpClient,
        super(const SelectCourseTeacherState());

  final HwdbHttpClient _httpClient;
  final CourseInfo courseInfo;

  Future<void> select(User teacher) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // ONLY TEACHERS SHOULD BE SELECTED
    if (teacher.role.isNotTeacher) {
      throw Exception('Only teachers should be selected');
    }

    // REQUEST TO UPDATE TEACHER
    final res = await _httpClient.patch('courses/${courseInfo.id}', args: {
      'teacherId': teacher.id,
    });

    // IF THE TEACHER IS SUCCESSFULLY UPDATED
    if (Events.updatedCourseInfo.matches(res['event'])) {
      // DIRECTLY UPDATE LOCAL DATA
      final newTeacher = teacher;
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.updatedCourseInfo,
        newTeacher: newTeacher,
      ));
    }

    // THROW ANY UNEXPECTED RESPONSE
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
