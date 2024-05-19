part of 'select_course_students_cubit.dart';

@immutable
class SelectCourseStudentsState extends Equatable {
  final PageStatus status;
  final Set<User> selected;
  final bool modified;
  final bool done;

  const SelectCourseStudentsState({
    this.status = PageStatus.good,
    this.selected = const {},
    this.modified = false,
    this.done = false,
  });

  SelectCourseStudentsState copyWith({
    PageStatus? status,
    Set<User>? selected,
    bool? modified,
    bool? done,
  }) {
    return SelectCourseStudentsState(
      status: status ?? this.status,
      selected: selected ?? this.selected,
      modified: modified ?? this.modified,
      done: done ?? this.done,
    );
  }

  @override
  List<Object> get props => [status, selected, modified, done];
}
