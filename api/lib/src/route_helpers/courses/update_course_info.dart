import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /courses/[courseId] => `CourseInfo`
Future<Response> updateCourseInfo(RequestContext context, Id courseId) async {
  await Ensure.isAdmin(context);

  // Get course info fields.
  final formData = await context.formData;
  final name = formData.fields['name'];
  final grade = ParseString.toGradeOrNull(formData.fields['grade']);
  final year = ParseString.toIntOrNull(formData.fields['year']);
  final teacherId = ParseString.toIdOrNull(formData.fields['teacherId']);
  final studentIds = ParseString.toIdListOrNull(formData.fields['studentIds']);

  // Validate course info fields.
  Validate.courseName(name);
  Validate.courseYear(year);

  // Ensure the provided teacherId corresponds to a valid teacher.
  if (teacherId != null) {
    await Ensure.isUserWithRole(context, teacherId, UserRole.teacher);
  }

  // Ensure the provided studentIds correspond to valid students
  if (studentIds != null) {
    await Ensure.areUsersWithRole(context, studentIds, UserRole.student);
  }

  // Get current course info.
  final getCourseInfoRes = await context.db.collection('courses').modernFindOne(
    filter: {'_id': courseId},
    projection: {'name': 1, 'grade': 1, 'year': 1},
  );

  if (getCourseInfoRes == null) {
    throw Exception('course');
  }

  // Ensure there are no duplicate courses.
  await Ensure.courseInfoNotInDb(
    context,
    name ?? getCourseInfoRes['name']!,
    grade ?? ParseString.toGradeOrNull(getCourseInfoRes['grade'])!,
    year ?? getCourseInfoRes['year']!,
  );

  // Update course.
  final updateCourseRes = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      '\$set': {
        if (name != null) 'name': name,
        if (grade != null) 'grade': grade.name,
        if (year != null) 'year': year,
        if (teacherId != null) 'teacherId': teacherId,
        if (studentIds != null) 'studentIds': studentIds,
      }
    },
  );

  await Ensure.hasNoWriteErrors(updateCourseRes);

  if (updateCourseRes.nModified != 1) {
    throw Exception('Nothing was modified.');
  }

  // Get new course info.
  final getNewCourseInfoRes = await context.db.collection('courses').modernAggregate([
    {
      '\$match': {'_id': courseId}
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
  final newCourseInfo = getNewCourseInfoRes.firstOrNull;

  if (newCourseInfo == null) {
    throw NotFound('course');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.updatedCourseInfo,
    'data': newCourseInfo,
  });
}
