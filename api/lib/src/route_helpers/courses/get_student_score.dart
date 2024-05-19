import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /courses/[courseId]/scores/student/[studentId] => {
///   `assignments: List<Assignment>`,
///   `scores: Scores`,
/// }
Future<Response> getStudentScore(RequestContext context, Id courseId, Id studentId) async {
  // Ensure current user is either the student himself, a course teacher, or an admin.
  final currentUser = await context.user;
  if (currentUser.id != studentId) {
    await Ensure.isCourseTeacherOrAdmin(context, courseId);
  }

  // Get student score info.
  final getStudentScoreRes = await context.db.collection('courses').modernFindOne(
    filter: {'_id': courseId},
    projection: {
      'assignments': 1,
      'scores.${fromId(studentId)}': 1,
    },
  );
 
  if (getStudentScoreRes == null) {
    throw NotFound('course');
  }

  final assignments = getStudentScoreRes['assignments'] ?? const [];
  final scores = getStudentScoreRes['scores'][fromId(studentId)] ?? Scores();

  // Send repsonse.
  return Response.json(body: {
    'event': Events.gotStudentCourseScore,
    'data': {
      'assignments': assignments,
      'scores': scores,
    }
  });
}
