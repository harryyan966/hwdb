import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /courses/[courseId]/scores => {
///   `assignments: List<Assignment>`,
///   `students: List<User>`,
///   `scores: MultiScores`,
///   `finalScores: Scores`,
/// }
Future<Response> getScoreboard(RequestContext context, Id courseId) async {
  await Ensure.isCourseTeacherOrAdmin(context, courseId);

  // Get score board info.
  final getScoreBoardRes = (await context.db.collection('courses').modernAggregate([
    {
      r'$match': {'_id': courseId}
    },
    {
      r'$lookup': {
        'from': 'users',
        'localField': 'studentIds',
        'foreignField': '_id',
        'pipeline': [
          {r'$project': Projections.user}
        ],
        'as': 'students',
      }
    },
    {r'$project': Projections.scoreboard},
  ]).toList());

  if (getScoreBoardRes.isEmpty) {
    throw NotFound('course');
  }

  final assignments = getScoreBoardRes.first['assignments'] ?? const [];
  final students = getScoreBoardRes.first['students'] ?? const [];
  final scores = getScoreBoardRes.first['scores'] ?? MultiScores();
  final finalScores = getScoreBoardRes.first['finalScores'] ?? Scores();

  // Send response.
  return Response.json(body: {
    'event': Events.gotScoreboard,
    'data': {
      'assignments': assignments,
      'students': students,
      'scores': scores,
      'finalScores': finalScores,
    },
  });
}
