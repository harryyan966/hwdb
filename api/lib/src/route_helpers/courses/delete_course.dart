import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// DELETE /courses/[courseId] => `void`
Future<Response> deleteCourse(RequestContext context, Id courseId) async {
  await Ensure.isAdmin(context);

  // Delete course from database.
  final deleteCourseRes = await context.db.collection('courses').deleteOne({'_id': courseId});

  await Ensure.hasNoWriteErrors(deleteCourseRes);

  if (deleteCourseRes.nRemoved != 1) {
    throw Exception('Nothing was deleted.');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.deletedCourse,
  });
}
