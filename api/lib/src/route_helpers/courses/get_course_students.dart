import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /courses/[courseId]/students => `List<User>`
Future<Response> getCourseStudents(RequestContext context, Id courseId) async {
  // Ensure the user is logged in.
  await context.user;

  // Get studentIds of the course.
  final getStudentIdsRes = await context.db.collection('courses').modernFindOne(
    filter: {'_id': courseId},
    projection: {'studentIds': 1},
  );
  final studentIds = getStudentIdsRes?['studentIds'];

  // If there are no studentIds
  if (studentIds == null) {
    throw NotFound('studentIds');
  }

  // Get students of the course.
  final getStudentsRes = await context.db.collection('users').modernFind(
    filter: {
      '_id': {'\$in': studentIds}
    },
    projection: Projections.user,
  ).toList();
  final students = getStudentsRes;

  // If there are ids that do not match students
  if (students.length != studentIds.length) {
    throw NotFound('student');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.gotStudents,
    'data': students,
  });
}
