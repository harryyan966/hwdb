part of 'edit_course_cubit.dart';

@immutable
class EditCourseState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, ValidationErrors> validationError;
  final User teacher;
  final List<User> students;
  final bool teacherModified;
  final bool studentsModified;
  final CourseInfo newCourseInfo;

  const EditCourseState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.teacher = const User.empty(),
    this.students = const [],
    this.teacherModified = false,
    this.studentsModified = false,
    this.validationError = const {},
    this.newCourseInfo = const CourseInfo.empty(),
  });

  List<User> get sortedStudents => students.isEmpty ? [] : students
    ..sort((a, b) => a.name.compareTo(b.name));

  EditCourseState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    User? teacher,
    List<User>? students,
    bool? teacherModified,
    bool? studentsModified,
    Map<String, ValidationErrors>? validationError,
    CourseInfo? newCourseInfo,
  }) {
    return EditCourseState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      validationError: validationError ?? const {},
      teacher: teacher ?? this.teacher,
      students: students ?? this.students,
      teacherModified: teacherModified ?? this.teacherModified,
      studentsModified: studentsModified ?? this.studentsModified,
      newCourseInfo: newCourseInfo ?? this.newCourseInfo,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      event,
      error,
      validationError,
      teacher,
      students,
      teacherModified,
      studentsModified,
      newCourseInfo,
    ];
  }
}
