import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PUT /courses/[courseId]/scores/midterm => `Scores`
Future<Response> generateMidtermScores(RequestContext context, Id courseId) async {
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

  // Calculate midterm scores.
  final assignments = ConversionTools.toJsonList(getCourseScoresRes['assignments'])
      .map((e) => e..update('id', (v) => fromId(v)))
      .toList();
  final scores = ConversionTools.toMultiScores(getCourseScoresRes['scores']);
  final midtermScores = ScoreTools.computeMidtermScores(assignments, scores);

  // Update final score in the database.
  final updateFinalScoresRes = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      '\$set': {'finalScores': midtermScores}
    },
  );

  await Ensure.hasNoWriteErrors(updateFinalScoresRes);

  return Response.json(body: {
    'event': Events.generatedMidtermScore,
    'data': midtermScores,
  });
}
