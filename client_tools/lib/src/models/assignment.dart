import 'package:const_date_time/const_date_time.dart';
import 'package:tools/tools.dart';

class Assignment extends Equatable {
  final String id;
  final String name;
  final AssignmentType type;
  final DateTime dueDate;

  const Assignment({
    required this.id,
    required this.name,
    required this.type,
    required this.dueDate,
  });

  const Assignment.empty()
      : id = '',
        name = '',
        type = AssignmentType.none,
        dueDate = const ConstDateTime(0);

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type.name,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] as String,
      name: map['name'] as String,
      type: AssignmentType.values.byName(map['type']),
      dueDate: DateTime.parse(map['dueDate']),
    );
  }

  @override
  List<Object> get props => [id, name, type, dueDate];
}
