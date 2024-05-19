import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'course_search_state.dart';

class CourseSearchCubit extends Cubit<CourseSearchState> {
  CourseSearchCubit({
    required HwdbHttpClient httpClient,
  })  : _httpClient = httpClient,
        super(const CourseSearchState());

  final HwdbHttpClient _httpClient;

  static const kLoadCount = 20;

  Future<void> getCourses() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // DO NOTHING IF THERE ARE NO MORE COURSES
    if (!state.hasMore) {
      return;
    }

    // GET COURSES FROM API
    final res = await _httpClient.get('courses', {
      'start': state.courses.length,
      'count': kLoadCount,
      if (state.keyword.isNotEmpty) 'name': state.keyword,
    });

    // IF THE COURSES ARE GOT SUCCESSFULLY
    if (Events.gotCourses.matches(res['event'])) {
      final List<CourseInfo> newCourses = ConversionTools.toJsonTypeList(res['data']['courses'], CourseInfo.fromJson);
      final bool hasMore = res['data']['hasMore'];
      emit(state.copyWith(
        status: PageStatus.good,
        courses: [...state.courses, ...newCourses],
        hasMore: hasMore,
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  Future<void> searchCourses(String keyword) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // GET COURSES FROM API
    final res = await _httpClient.get('courses', {
      'count': kLoadCount,
      if (keyword.isNotEmpty) 'name': keyword,
    });

    // IF THE COURSES ARE GOT SUCCESSFULLY
    if (Events.gotCourses.matches(res['event'])) {
      final List<CourseInfo> newCourses = ConversionTools.toJsonTypeList(res['data']['courses'], CourseInfo.fromJson);
      final bool hasMore = res['data']['hasMore'];
      emit(state.copyWith(
        status: PageStatus.good,
        courses: newCourses,
        hasMore: hasMore,
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  Future<void> reLoad() async {
    await searchCourses(state.keyword);
  }

  Future<void> deleteCourse(String id) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // DELETE COURSE FROM API
    final res = await _httpClient.delete('courses/$id');

    // IF THE COURSE IS DELETED SUCCESSFULLY
    if (Events.deletedCourse.matches(res['event'])) {
      // DIRECTLY UPDATE LOCAL DATA
      emit(state.copyWith(
        status: PageStatus.good,
        courses: List.from(state.courses)..removeWhere((e) => e.id == id),
      ));
    }

    // THROW ANY EXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
