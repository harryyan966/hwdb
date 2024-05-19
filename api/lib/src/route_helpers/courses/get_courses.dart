import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /courses => {
///   `courses: List<CourseInfo>`,
///   `hasMore: bool`,
/// }
Future<Response> getCourses(RequestContext context) async {
  // Ensure the user is logged in.
  await context.user;

  // Get filter arguments.
  final qargs = context.qargs;
  final start = ParseString.toIntOrNull(qargs['start']);
  final count = ParseString.toIntOrNull(qargs['count']) ?? kSingleGetCount;
  final name = qargs['name'];
  final grade = ParseString.toGradeOrNull(qargs['grade']);
  final year = ParseString.toIntOrNull(qargs['year']);

  // Construct filter.
  final currentUser = await context.user;
  final filter = {
    if (name != null) 'name': {r'$regex': name, r'$options': 'i'},
    if (grade != null) 'grade': grade.name,
    if (year != null) 'year': year,

    // Get courses that the student is in only.
    if (currentUser.role.isStudent) 'studentIds': currentUser.id,

    // Get courses that the teacher owns only.
    if (currentUser.role.isTeacher) 'teacherId': currentUser.id,
  };

  // Get matched course info.
  final getCoursesRes = await context.db.collection('courses').modernAggregate([
    if (start != null && start != 0) {r'$skip': start},
    {r'$limit': count},
    {r'$match': filter},

    // Get teacher info with teacherId.
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

    // Convert `teacher` field from list to json
    {r'$unwind': r'$teacher'},

    // Include only the required fields only.
    {r'$project': Projections.courseInfo},
  ]).toList();
  final courses = getCoursesRes;

  // Determine whether there are more courses.
  final countCoursesRes = await context.db.collection('courses').modernCount(skip: start, filter: filter);
  final hasMore = countCoursesRes.count > count;

  // Send response.
  return Response.json(body: {
    'event': Events.gotCourses,
    'data': {
      'courses': courses,
      'hasMore': hasMore,
    }
  });
}
