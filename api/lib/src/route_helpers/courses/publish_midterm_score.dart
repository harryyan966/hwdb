import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /courses/[courseId]/scores/midterm => `void`
Future<Response> publishMidtermScores(RequestContext context, Id courseId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Get course score info.
  final getFinalScoresRes = await context.db.collection('courses').modernFindOne(
    filter: {'_id': courseId},
    projection: {'assignments': 1, 'finalScores': 1},
  );

  if (getFinalScoresRes == null) {
    throw NotFound('course');
  }

  // Ensure assignments meet publishable standards.
  final assignments = ConversionTools.toJsonList(getFinalScoresRes['assignments'] ?? []);
  try {
    ScoreTools.validateAssignmentsForMidterm(assignments.map((e) => e..update('id', (v) => fromId(v))).toList());
  } on Exception {
    throw BadRequest(Errors.insufficientAssignmentList);
  }

  // Get final scores.
  final finalScores = getFinalScoresRes['finalScores'] ?? {};

  // TODO: is this relational paradigm a good one?
  // Write final scores in the database as official midterm scores.
  final updateMidtermScoresRes = await context.db.collection('scores').bulkWrite([
    for (final finalScore in finalScores.entries)
      {
        'updateOne': {
          'filter': {
            'studentId': toId(finalScore.key),
            'courseId': courseId,
            'type': ScoreRecordType.midtermRecord.name,
          },
          'update': {
            r'$set': {'score': finalScore.value}
          },
          'upsert': true,
        }
      }
  ]);

  await Ensure.hasNoBulkWriteErrors(updateMidtermScoresRes);

  // DEBUG MESSAGE
  if (updateMidtermScoresRes.nUpserted != finalScores.length) {
    print('Modified less amount of documents than expected in publish final scores.');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.publishedMidtermScore,
  });
}
