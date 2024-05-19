import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /courses/[courseId]/assignments/[assignmentid] => `void`
Future<Response> updateAssignment(RequestContext context, Id courseId, Id assignmentId) async {
  await Ensure.isCourseTeacher(context, courseId);

  // Get assignment info fields.
  final formData = await context.formData;
  final name = formData.fields['name'];
  final type = ParseString.toAssignmentTypeOrNull(formData.fields['type']);
  final dueDate = ParseString.toDateOrNull(formData.fields['dueDate']);

  // Validate assignment fields.
  Validate.assignmentName(name);
  Validate.assignmentDueDate(dueDate);

  // Ensure there are no duplicate assignments in the course.
  await Ensure.assignmentInfoNotInDb(context, courseId, name, type);

  // Update assignment in the database.
  final updateAssignmentRes = await context.db.collection('courses').updateOne(
    {
      '_id': courseId,
      'assignments.id': assignmentId,
    },
    {
      r'$set': {
        if (name != null) r'assignments.$.name': name,
        if (type != null) r'assignments.$.type': type.name,
        if (dueDate != null) r'assignments.$.dueDate': dueDate.toIso8601String(),
      },
    },
  );

  await Ensure.hasNoWriteErrors(updateAssignmentRes);

  // TODO: should we send the new assignment?
  // Send response.
  return Response.json(body: {
    'event': Events.updatedAssignment,
  });
}
