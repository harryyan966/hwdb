import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PUT /courses/[courseId]/scores/final => `Scores`
Future<Response> generateFinalScores(RequestContext context, Id courseId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Get course scores.
  final getCourseScoresRes = (await context.db.collection('courses').modernFindOne(
    filter: {'_id': courseId},
    projection: {
      '_id': 0,
      'assignments': 1,
      'scores': 1,
    },
  ));

  if (getCourseScoresRes == null) {
    throw NotFound('course');
  }

  // Calculate final scores.
  final assignments = ConversionTools.toJsonList(getCourseScoresRes['assignments'] ?? [])
      .map((e) => e..update('id', (v) => fromId(v)))
      .toList();
  final scores = ConversionTools.toMultiScores(getCourseScoresRes['scores'] ?? {});
  final finalScores = ScoreTools.computeFinalScores(assignments, scores);

  // Update final score in the database.
  final updateFinalScoresRes = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      '\$set': {'finalScores': finalScores}
    },
  );

  await Ensure.hasNoWriteErrors(updateFinalScoresRes);

  return Response.json(body: {
    'event': Events.generatedFinalScore,
    'data': finalScores,
  });
}
