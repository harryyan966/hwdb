import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'select_course_students_state.dart';

class SelectCourseStudentsCubit extends Cubit<SelectCourseStudentsState> {
  SelectCourseStudentsCubit({
    required this.courseId,
    required List<User> students,
  }) : super(SelectCourseStudentsState(selected: students.toSet()));

  final String courseId;

  // Future<void> getCourseStudents() async {
  //   if (state.status.isLoading) return;
  //   emit(state.copyWith(status: PageStatus.loading));

  //   // GET COURSE STUDENTS
  //   final res = await _httpClient.get('courses/$courseId/students');

  //   // IF THE STUDENTS ARE GOT SUCCESSFULLY
  //   if (Events.gotStudents.matches(res['event'])) {
  //     final Set<User> courseStudents = toJsonList(res['data']).map(User.fromJson).toSet();
  //     emit(state.copyWith(
  //       status: PageStatus.good,
  //       selected: courseStudents,
  //     ));
  //   }

  //   // THROW ANY UNEXPECTED ERROR
  //   else {
  //     emit(state.copyWith(status: PageStatus.bad));
  //     throw Exception(res.pretty());
  //   }
  // }

  void toggle(User student) {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // ONLY STUDENTS SHOULD BE SELECTED
    if (student.role.isNotStudent) {
      throw Exception('Only students should be selected');
    }

    // REMOVE STUDENT IF SELECTED ALREADY
    if (state.selected.contains(student)) {
      // state.selected.remove(student);
      final newSelectedList = Set<User>.from(state.selected)..remove(student);
      emit(state.copyWith(
        status: PageStatus.good,
        selected: newSelectedList,
        modified: true,
      ));
    }

    // ADD STUDENT IF NOT SELECTED
    else {
      // state.selected.add(student);
      final newSelectedList = Set<User>.from(state.selected)..add(student);
      emit(state.copyWith(
        status: PageStatus.good,
        selected: newSelectedList,
        modified: true,
      ));
    }
  }

  void updateCourseStudentList() {
    emit(state.copyWith(done: true));
  }

  // Future<void> updateCourseStudentList() async {
  //   // DON'T NEED TO UPDATE AS NOTHING IS MODIFIED
  //   if (!state.modified) {
  //     emit(state.copyWith(done: true));
  //     return;
  //   }

  //   if (state.status.isLoading) return;
  //   emit(state.copyWith(status: PageStatus.loading));

  //   // REQUEST TO UPDATE STUDENTS
  //   final res = await _httpClient.put('courses/$courseId/students', args: {
  //     'studentIds': state.selected.map((e) => e.id).toList(),
  //   });

  //   // IF THE STUDENTS ARE SUCCESSFULLY UPDATED
  //   if (Events.updatedCourseStudentList.matches(res['event'])) {
  //     emit(state.copyWith(
  //       status: PageStatus.good,
  //       done: true,
  //     ));
  //   }

  //   // THROW ANY UNEXPECTED RESPONSE
  //   else {
  //     emit(state.copyWith(status: PageStatus.bad));
  //     throw Exception(res.pretty());
  //   }
  // }
}
