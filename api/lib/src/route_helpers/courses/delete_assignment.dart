import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// DELETE /courses/[courseId]/assignments/[assignmentId] => `void`
Future<Response> deleteAssignment(RequestContext context, Id courseId, Id assignmentId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Delete the assignment from the database.
  final deleteAssignmentRes = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      r'$pull': {
        'assignments': {'id': assignmentId}
      }
    },
  );

  await Ensure.hasNoWriteErrors(deleteAssignmentRes);

  if (deleteAssignmentRes.nModified != 1) {
    throw Exception('Nothing was deleted.');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.deletedAssignment,
  });
}
