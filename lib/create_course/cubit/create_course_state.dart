part of 'create_course_cubit.dart';

@immutable
class CreateCourseState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, ValidationErrors> validationError;
  final User teacher;
  final List<User> students;
  final CourseInfo newCourse;

  const CreateCourseState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.validationError = const {},
    this.teacher = const User.empty(),
    this.students = const [],
    this.newCourse = const CourseInfo.empty(),
  });

  CreateCourseState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, ValidationErrors>? validationError,
    User? teacher,
    List<User>? students,
    CourseInfo? newCourse,
  }) {
    return CreateCourseState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      validationError: validationError ?? const {},
      teacher: teacher ?? this.teacher,
      students: students ?? this.students,
      newCourse: newCourse ?? this.newCourse,
    );
  }

  @override
  List<Object> get props => [status, event, error, validationError, teacher, students, newCourse];
}
