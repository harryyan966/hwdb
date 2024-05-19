import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /scorereports/student/[studentId] => `List<ScoreRecord>`
Future<Response> getStudentScoreReport(RequestContext context, Id studentId) async {
  await Ensure.isAdmin(context);

  // Get student score report
  final getStudentScoreReportRes = await context.db.collection('scores').modernAggregate([
    {
      r'$match': {'studentId': studentId}
    },

    // Get courseInfo with courseId.
    {
      r'$lookup': {
        'from': 'courses',
        'localField': 'courseId',
        'foreignField': '_id',
        'pipeline': [
          // Get teacherInfo with teacherId.
          {
            r'$lookup': {
              'from': 'users',
              'localField': 'teacherId',
              'foreignField': '_id',
              'pipeline': [
                {r'$project': Projections.user}
              ],
              'as': 'teacher',
            }
          },

          // Convert `teacher` field from list to json.
          {r'$unwind': r'$teacher'},

          // Get requried fields only.
          {r'$project': Projections.courseInfo},
        ],
        'as': 'course',
      },
    },

    // Convert `course` field from list to json.
    {r'$unwind': r'$course'},
  ]).toList();
  final studentScoreRecords = getStudentScoreReportRes;

  // Send response.
  return Response.json(body: {
    'event': Events.gotStudentScoreReport,
    'data': studentScoreRecords,
  });
}
