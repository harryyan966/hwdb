import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:tools/tools.dart';

part 'edit_course_state.dart';

class EditCourseCubit extends Cubit<EditCourseState> {
  EditCourseCubit({
    required HwdbHttpClient httpClient,
    required this.courseInfo,
  })  : _httpClient = httpClient,
        super(EditCourseState(teacher: courseInfo.teacher));

  final HwdbHttpClient _httpClient;
  final CourseInfo courseInfo;

  Future<void> getStudents() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // REQUEST FOR STUDENTS
    final res = await _httpClient.get('courses/${courseInfo.id}/students');

    // IF STUDENTS ARE RETURNED
    if (Events.gotStudents.matches(res['event'])) {
      final students = ConversionTools.toJsonTypeList(res['data'], User.fromJson);

      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.gotStudents,
        students: students,
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  Future<void> editCourseInfo({
    String? name,
    Grade? grade,
    int? year,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // REQUEST TO UPDATE COUSRE INFO
    final res = await _httpClient.patch('courses/${courseInfo.id}', args: {
      'name': name,
      'grade': grade?.name,
      'year': year,
      if (state.teacherModified) 'teacherId': state.teacher.id,
      if (state.studentsModified) 'studentIds': state.students.map((e) => e.id),
    });

    // IF THE COURSE IS UPDATED SUCCESSFULLY
    if (Events.updatedCourseInfo.matches(res['event'])) {
      res['data']['teacher'] = state.teacher.toJson();
      final newCourseInfo = CourseInfo.fromJson(res['data']);
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.updatedCourseInfo,
        newCourseInfo: newCourseInfo,
      ));
    }

    // IF THERE IS A FIELD VALIDATION ERROR
    else if (Errors.validationError.matches(res['error'])) {
      final validationError = toValidationError(res['data']);
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.validationError,
        validationError: validationError,
      ));
    }

    // THROW THE UNEXPECTED RESPONSE
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  void updateTeacher(User teacher) {
    if (teacher != state.teacher) {
      emit(state.copyWith(teacher: teacher, teacherModified: true));
    }
  }

  void updateStudents(List<User> students) {
    if (!listEquals(students, state.students)) {
      emit(state.copyWith(students: students, studentsModified: true));
    }
  }
}
