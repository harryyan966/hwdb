part of 'course_search_cubit.dart';

@immutable
class CourseSearchState extends Equatable {
  final PageStatus status;
  final List<CourseInfo> courses;
  final bool hasMore;
  final String keyword;

  const CourseSearchState({
    this.status = PageStatus.good,
    this.courses = const [],
    this.hasMore = true,
    this.keyword = '',
  });

  CourseSearchState copyWith({
    PageStatus? status,
    List<CourseInfo>? courses,
    bool? hasMore,
    String? keyword,
  }) {
    return CourseSearchState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      hasMore: hasMore ?? this.hasMore,
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  List<Object> get props => [status, courses,hasMore, keyword];
}
