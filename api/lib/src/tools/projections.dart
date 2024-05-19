class Projections {
  Projections._();

  static Map<String, Object> id = {
    '_id': 0,
    'id': r'$_id',
  };

  static Map<String, Object> user = {
    '_id': 0,
    'id': r'$_id',
    'name': 1,
    'role': 1,
    'profileImageUrl': 1,
  };

  static Map<String, Object> fullUser = user..addAll({'password': 1});

  static Map<String, Object> courseInfo = {
    '_id': 0,
    'id': r'$_id',
    'name': 1,
    'teacher': 1,
    'grade': 1,
    'year': 1,
  };

  static Map<String, Object> assignment = {
    'id': 1,
    'name': 1,
    'type': 1,
    'dueDate': 1,
  };

  static Map<String, Object> scoreboard = {
    'students': 1,
    'assignments': 1,
    'scores': 1,
    'finalScores': 1,
  };
}
