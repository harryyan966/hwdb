import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

/// Note: this implementation of the client model is not going to address potential performancce concerns with loading every student in the class list page.
/// That is, although we are not going to use student information in the class list page, we are still going to load them for simplicity of implementation.
/// TODO: assess the validity of this approach. Is is just simpler to separate the "list model" and the "detail model" (i.e. "ClassListItem", and "ClassDetailModel")
class ClassInfo extends Equatable {
  final String id;
  final String name;
  final User teacher;
  final List<User> students;

  const ClassInfo({
    required this.id,
    required this.name,
    required this.teacher,
    required this.students,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'teacher': teacher.toJson(),
      'students': students.map((x) => x.toJson()).toList(),
    };
  }

  factory ClassInfo.fromJson(Map<String, dynamic> map) {
    return ClassInfo(
      id: map['id'] as String,
      name: map['name'] as String,
      teacher: User.fromJson(map['teacher'] as Map<String, dynamic>),
      students: List<User>.from(
        (map['students'] as List<int>).map<User>(
          (x) => User.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  List<Object> get props => [id, name, teacher, students];
}
