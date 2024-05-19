import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /courses/[courseId]/scores/student/[studentId]/final => `void`
Future<Response> updateFinalScore(RequestContext context, Id courseId, Id studentId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Get score.
  final formData = await context.formData;
  final double? score = ParseString.toDoubleOrNull(formData.fields['score']);

  // Ensure the studentId corresponds to a student in the course.
  await Ensure.areStudentsInCourse(context, [studentId], courseId);

  // Update final score in the database.
  final updateFinalScoreResult = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      r'$set': {'finalScores.${fromId(studentId)}': score}
    },
  );

  await Ensure.hasNoWriteErrors(updateFinalScoreResult);

  if (updateFinalScoreResult.nModified != 1) {
    throw Exception('Nothing was modified');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.updatedCourseFinalScore,
  });
}
