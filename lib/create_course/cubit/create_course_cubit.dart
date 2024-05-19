import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'create_course_state.dart';

class CreateCourseCubit extends Cubit<CreateCourseState> {
  CreateCourseCubit({
    required HwdbHttpClient httpClient,
  })  : _httpClient = httpClient,
        super(const CreateCourseState());

  final HwdbHttpClient _httpClient;

  Future<void> createCourse({
    required String name,
    required Grade grade,
    required int year,
    required String teacherId,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // CREATE THE COURSE IN THE SERVER
    final res = await _httpClient.post('courses', args: {
      "name": name,
      "grade": grade.name,
      "year": year,
      "teacherId": teacherId,
      // "studentIds": state.students.map((e) => e.id),
    });

    // IF THE COURSE IS CREATED SUCCESSFULLY
    if (Events.createdCourse.matches(res['event'])) {
      final CourseInfo newCourse = CourseInfo.fromJson(res['data']);
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.createdCourse,
        newCourse: newCourse,
      ));
    }

    // IF THE SERVER THREW A VALIDATION ERROR
    else if (Errors.validationError.matches(res['error'])) {
      final validationError = toValidationError(res['data']);
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.validationError,
        validationError: validationError,
      ));
    }

    // THROW ANY UNEXPECTED RESULTS
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
