import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /courses => `CourseInfo`
Future<Response> createCourse(RequestContext context) async {
  await Ensure.isAdmin(context);

  // Get new course info.
  final formData = await context.formData;
  final name = formData.fields['name']!;
  final grade = ParseString.toGradeOrNull(formData.fields['grade'])!;
  final year = ParseString.toIntOrNull(formData.fields['year'])!;
  final teacherId = toId(formData.fields['teacherId']!);

  // Validate course info.
  Validate.courseName(name);
  Validate.courseYear(year);

  // Ensure there are no duplicate courses.
  await Ensure.courseInfoNotInDb(context, name, grade, year);

  // Ensure the provided teacherId corresponds to a valid teacher.
  await Ensure.isUserWithRole(context, teacherId, UserRole.teacher);

  // Write the new course in the database.
  final createCourseRes = await context.db.collection('courses').insertOne({
    'name': name,
    'grade': grade.name,
    'year': year,
    'teacherId': teacherId,
    'studentIds': [],
    'assignments': [],
    'scores': {},
  });

  await Ensure.hasNoWriteErrors(createCourseRes);

  if (createCourseRes.nInserted != 1) {
    throw Exception('Nothing was created.');
  }

  // Get new course info that is to be sent back to the client.
  final getNewCourseRes = await context.db.collection('courses').modernAggregate([
    {
      r'$match': {'_id': createCourseRes.id}
    },

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
  final newCourse = getNewCourseRes.firstOrNull;

  if (newCourse == null) {
    throw NotFound('new course');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.createdCourse,
    'data': newCourse,
  });
}
