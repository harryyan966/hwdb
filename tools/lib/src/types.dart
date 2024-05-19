typedef Json = Map<String, dynamic>;
typedef Scores = Map<String, double?>;
typedef MultiScores = Map<String, Map<String, double?>>;

enum UserRole {
  none,
  student,
  teacher,
  admin;

  bool get isAdmin => this == UserRole.admin;
  bool get isTeacher => this == UserRole.teacher;
  bool get isStudent => this == UserRole.student;

  bool get isNotAdmin => this != UserRole.admin;
  bool get isNotTeacher => this != UserRole.teacher;
  bool get isNotStudent => this != UserRole.student;

  bool get isNotEmpty => this != UserRole.none;
}

enum AssignmentType {
  none(0, true, 0),
  homework(10, false, 0.3),
  quiz(4, false, 0.3),
  midtermExam(1, true, 0.1),
  finalExam(1, true, 0.2),
  participation(1, true, 0.1);

  const AssignmentType(this.countLimit, this.hasStrictCountLimit, this.weight);
  final int countLimit;
  final bool hasStrictCountLimit;
  final double weight;
}

enum Grade {
  none,
  g10fall,
  g10spring,
  g11fall,
  g11spring,
  g12fall,
  g12spring,
}

enum ScoreRecordType {
  midtermRecord,
  finalRecord,
}
