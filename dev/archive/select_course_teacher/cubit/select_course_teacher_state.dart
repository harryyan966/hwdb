part of 'select_course_teacher_cubit.dart';

@immutable
class SelectCourseTeacherState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final User newTeacher;

  const SelectCourseTeacherState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.newTeacher = const User.empty(),
  });

  SelectCourseTeacherState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    User? newTeacher,
  }) {
    return SelectCourseTeacherState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      newTeacher: newTeacher ?? this.newTeacher,
    );
  }

  @override
  List<Object?> get props => [status, event, error, newTeacher];
}
