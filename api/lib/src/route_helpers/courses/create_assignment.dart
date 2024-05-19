import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /courses/[courseId]/assignment => `Assignment`
Future<Response> createAssignment(RequestContext context, Id courseId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Get new assignment info.
  final formData = await context.formData;
  final name = formData.fields['name']!;
  final type = ParseString.toAssignmentTypeOrNull(formData.fields['type'])!;
  final dueDate = ParseString.toDateOrNull(formData.fields['dueDate'])!;

  // Validate assignment info.
  Validate.assignmentName(name);
  Validate.assignmentDueDate(dueDate);

  // Ensure there are no duplicate assignments in the course.
  await Ensure.assignmentInfoNotInDb(context, courseId, name, type);

  // Construct the new assignment.
  final newAssignment = {
    'id': newId(),
    'name': name,
    'type': type.name,
    'dueDate': dueDate.toIso8601String(),
  };

  // Write the assignment in the database.
  final createAssignmentRes = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      '\$push': {'assignments': newAssignment},
    },
  );

  await Ensure.hasNoWriteErrors(createAssignmentRes);

  if (createAssignmentRes.nModified != 1) {
    throw Exception('Nothing was modified.');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.createdAssignment,
    'data': newAssignment,
  });
}
