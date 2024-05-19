import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /courses/[courseId]/scores/student/[studentId] => `void`
Future<Response> updateScore(RequestContext context, Id courseId, Id studentId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Get assignment and score.
  final formData = await context.formData;
  final Id assignmentId = toId(formData.fields['assignmentId']!);
  final double? score = ParseString.toDoubleOrNull(formData.fields['score']);

  // Ensure both the studentId and the assignmentId correspond to items in the course.
  await Ensure.isStudentAssignmentPairInCourse(context, studentId, assignmentId, courseId);

  // Update score in the database.
  final updateScoreRes = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      r'$set': {'scores.${fromId(studentId)}.${fromId(assignmentId)}': score}
    },
  );

  await Ensure.hasNoWriteErrors(updateScoreRes);

  if (updateScoreRes.nModified != 1) {
    throw Exception('Nothing was modified');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.updatedCourseScore,
  });
}
