
// Map<String, AssignmentType> _normalizeAssignments(Iterable<Json> assignments) {
//   return {
//     for (final assignment in assignments)
//       assignment['id']:
//           assignment['type'] is AssignmentType ? assignment['type'] : AssignmentType.values.byName(assignment['type']),
//   };
// }

// double? toFinalScore(Iterable<Json> assignments, Scores scores) {
//   return _mergeScores(_normalizeAssignments(assignments), scores);
// }

// double? _mergeScores(Map<String, AssignmentType> assignments, Scores scores, [bool isFinal = true]) {
//   if (scores.isEmpty) {
//     return null;
//   }

//   // CALCULATE FINAL SCORE
//   Map<AssignmentType, List<double>> scoresByType = {};
//   double weightedScoreSum = 0;
//   double weightSum = 0;

//   // SORT EACH SCORE TO THEIR ASSIGNMENT TYPES
//   for (final assignment in assignments.entries) {
//     // GET ASSIGNMENT TYPE
//     final assignmentId = assignment.key;
//     final assignmentType = assignment.value;
//     if (assignmentType == AssignmentType.none) {
//       throw Exception('Assignment type is none, which is disallowed');
//     }

//     // ADD SCORE TO ITS TYPE
//     if (scores[assignmentId] != null) {
//       scoresByType[assignmentType] ??= [];
//       scoresByType[assignmentType]!.add(scores[assignmentId]!);
//     }
//   }

//   for (final uniqueType in AssignmentType.values.where((e) => e.countLimit == 1)) {
//     if (scoresByType[uniqueType] != null && scoresByType[uniqueType]!.length > 1) {
//       throw Exception('UNIQUE ASSIGNMENT TYPES COULD NOT HAVE MORE THAN ONE ENTRY');
//     }
//   }

//   // ADD A WEIGHTED SCORE FOR EACH TYPE
//   for (final entry in scoresByType.entries) {
//     final assignmentType = entry.key;

//     // GET THE HIGHEST SCORES OF A STUDENT
//     final scores = entry.value
//       ..sort((a, b) => b.compareTo(a))
//       ..take(assignmentType.countLimit * (isFinal ? 2 : 1)); // THERE ARE TWO OF EACH TYPE

//     final averageScore = scores.fold(0.0, (p, c) => p + c) / scores.length;
//     weightedScoreSum += assignmentType.weight * averageScore;
//     weightSum += assignmentType.weight;
//   }

//   if (weightSum == 0) {
//     throw Exception('There are assignments and the weight sum is zero');
//   }

//   // SET FINAL SCORE
//   return double.parse((weightedScoreSum / weightSum).toStringAsFixed(1));
// }

// Scores toFinalScores(Iterable<Json> assignments, MultiScores scores) {
//   final finalScores = <String, double?>{};

//   // FOR EVERY STUDENT
//   for (final scoreEntry in scores.entries) {
//     final studentId = scoreEntry.key;
//     final studentScore = scoreEntry.value;
//     final normalizedAssignments = _normalizeAssignments(assignments);
//     finalScores[studentId] = _mergeScores(normalizedAssignments, studentScore);
//   }

//   return finalScores;
// }
