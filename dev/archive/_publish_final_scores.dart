// final updateFinalScoreResult = await context.db.collection('courses').updateOne(
  //   {'courseId': courseId},
  //   {
  //     '\$set': {'officialFinalScores': finalScores}
  //   },
  // );




  
// Future<Response> publishFinalScoresOld(RequestContext context, Id courseId) async {
//   await Ensure.isCourseTeacher(context, courseId);

//   // Get score-related information from the course, including students, assignments, and scores.
//   final courseScores = (await context.db.collection('courses').modernFindOne(
//     filter: {'_id': courseId},
//     projection: {'finalScores': 1},
//   ));

//   if (courseScores == null) {
//     throw NotFound();
//   }

//   // Prepare assignment list for final score calculation.
//   final List<Json> assignments = ConversionTools.toJsonList(courseScores['assignments']);
//   for (int i = 0; i < assignments.length; i++) {
//     assignments[i]['id'] = fromId(assignments[i]['id']);
//   }

//   // Validate assignment list for publishable final scores.
//   ScoreTools.validateAssignmentsForFinal(assignments);

//   // Prepare all scores for final score calculation.
//   final Set<String> studentIds = (courseScores['studentIds'] as List).map((e) => fromId(e as Id)).toSet();
//   final MultiScores scores = ConversionTools.toMultiScores(courseScores['scores'])
//     ..removeWhere((studentId, _) => !studentIds.contains(studentId));

//   // Calculate final score.
//   final finalScores = ScoreTools.computeFinalScores(assignments, scores);

//   // Write official final scores in the database.
//   // TODO: IS THIS A RELATIONAL PARADIGM?
//   final updateFinalScoreResult = await context.db.collection('scores').bulkWrite([
//     for (final finalScore in finalScores.entries)
//       {
//         'updateOne': {
//           'filter': {
//             'studentId': toId(finalScore.key),
//             'courseId': courseId,
//             'type': ScoreRecordType.finalRecord.name,
//           },
//           'update': {
//             r'$set': {'score': finalScore.value}
//           },
//           'upsert': true,
//         }
//       }
//   ]);
//   // final updateFinalScoreResult = await context.db.collection('courses').updateOne(
//   //   {'courseId': courseId},
//   //   {
//   //     '\$set': {'officialFinalScores': finalScores}
//   //   },
//   // );

//   if (updateFinalScoreResult.hasWriteErrors) {
//     throw Exception('SOMETHING WENT WRONG');
//   }

//   if (updateFinalScoreResult.nUpserted != finalScores.length) {
//     print('Modified less amount of documents than expected in publish final scores.');
//   }

//   // if (updateFinalScoreResult.nModified != 1) {
//   //   print('didn\'t change anything');
//   // }

//   return Response.json(body: {
//     'event': Events.publishedFinalScore,
//     'data': finalScores,
//   });
// }
