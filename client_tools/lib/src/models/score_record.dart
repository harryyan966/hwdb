import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

class ScoreRecord extends Equatable {
  final ScoreRecordType type;
  final CourseInfo course;
  final double? score;

  const ScoreRecord({
    required this.type,
    required this.course,
    this.score,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.name,
      'course': course.toJson(),
      'score': score,
    };
  }

  factory ScoreRecord.fromJson(Map<String, dynamic> map) {
    return ScoreRecord(
      type: ScoreRecordType.values.byName(map['type']),
      course: CourseInfo.fromJson(map['course'] as Map<String, dynamic>),
      score: map['score'] != null ? map['score'] as double : null,
    );
  }

  @override
  List<Object?> get props => [type, course, score];
}
