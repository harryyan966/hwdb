import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

@Deprecated('Use update score instead.')
Future<Response> replaceScoreboard(RequestContext context, Id courseId) async {
  // CHECK PERMISSIONS
  await Ensure.isCourseTeacher(context, courseId);

  // EXTRACT ARGUMENTS
  final formData = await context.formData;
  final MultiScores scores = ParseString.toMultiScoresOrNull(formData.fields['scores'])!;

  // VALIDATE ARGUMENTS

  // ENSURE ALL IDS IN THE SCORES ARE STUDENT IDS
  final studentIds = scores.keys.map(toId);

  // ENSURE ALL IDS IN STUDENT SCORES ARE ASSIGNMENT IDS
  final Set<String> assignmentIds = {};
  for (final score in scores.values) {
    assignmentIds.addAll(score.keys);
  }

  // CHECK THESE IDS
  final matchingCourses = await context.db.collection('courses').count({
    '_id': courseId,
    'studentIds': {r'$all': studentIds},
    'assignments.id': {r'$all': assignmentIds.toList()},
  });

  // SOME STUDENT IDS OR ASSIGNMENT IDS ARE NOT IN THE COURSE
  if (matchingCourses != 1) {
    throw BadRequest(Errors.invalidArguments);
  }

  // final courseObjects = await context.db.collection('courses').modernFindOne(
  //   filter: {'_id': courseId},
  //   projection: {
  //     'studentIds': 1,
  //     'assignments.id': 1,
  //   },
  // );
  // if (courseObjects == null) {
  //   throw NotFound();
  // }

  // // ENSURE ALL IDS IN THE SCORES ARE STUDENT IDS
  // final Set<String> studentIds = courseObjects['studentIds'].map(fromId).toSet();
  // if (!studentIds.containsAll(scores.keys)) {
  //   throw BadRequest(Errors.invalidArguments);
  // }

  // // ENSURE ALL IDS IN STUDENT SCORES ARE ASSIGNMENT IDS
  // final Set<String> assignmentIds = courseObjects['assignments'].map((e) => e['id']).toSet();
  // for (final score in scores.values) {
  //   if (!assignmentIds.containsAll(score.keys)) {
  //     throw BadRequest(Errors.invalidArguments);
  //   }
  // }

  // MODIFY DATA POOL
  await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      r'$set': {'scores': scores}
    },
  );

  // SEND RESPONSE
  return Response.json(body: {
    'event': Events.updatedCourseScores,
  });
}
