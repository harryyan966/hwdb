import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

class CourseInfo extends Equatable {
  final String id;
  final String name;
  final User teacher;
  final Grade grade;
  final int year;

  const CourseInfo({
    required this.id,
    required this.name,
    required this.teacher,
    required this.grade,
    required this.year,
  });

  const CourseInfo.empty()
      : id = '',
        name = '',
        teacher = const User.empty(),
        grade = Grade.none,
        year = -1;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'teacher': teacher.toJson(),
      'grade': grade.name,
      'year': year,
    };
  }

  factory CourseInfo.fromJson(Map<String, dynamic> map) {
    return map.isEmpty
        ? CourseInfo.empty()
        : CourseInfo(
            id: map['id'] as String,
            name: map['name'] as String,
            teacher: User.fromJson(map['teacher'] as Map<String, dynamic>),
            grade: Grade.values.byName(map['grade']),
            year: map['year'] as int,
          );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      teacher,
      grade,
      year,
    ];
  }
}
