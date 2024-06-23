import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /classes/[classId] => `void`
///
/// NOTE: The new api is not going to return the updated object.
Future<Response> updateClass(RequestContext context, Id classId) async {
  await Ensure.isAdmin(context);

  // Get new class info.
  final formData = await context.formData;
  final name = formData.fields['name'];
  final teacherId = ParseString.toIdOrNull(formData.fields['teacherId']);
  final studentIds = ParseString.toIdListOrNull(formData.fields['studentIds']);

  // Ensure there is at least one update.
  if (name == null && teacherId == null && studentIds == null) {
    throw BadRequest(Errors.emptyRequest);
  }

  // Validate class info.
  Validate.className(name);

  // Ensure the provided teacherId corresponds to a valid teacher.
  if (teacherId != null) {
    await Ensure.isUserWithRole(context, teacherId, UserRole.teacher);
  }

  // Ensure the provided studentIds correspond to valid students.
  if (studentIds != null) {
    await Ensure.areUsersWithRole(context, studentIds, UserRole.student);
  }

  // Ensure the class name is not duplicated in the database.
  if (name != null) {
    await Ensure.classInfoNotInDb(context, name);
  }

  // Save the new class.
  final updateClassRes = await context.db.collection('classes').updateOne({
    '_id': classId
  }, {
    '\$set': {
      if (name != null) {'name': name},
      if (teacherId != null) {'teacherId': teacherId},
      if (studentIds != null) {'studentIds': studentIds},
    }
  });
  await Ensure.hasNoWriteErrors(updateClassRes);

  // Ensure that a class is updated.
  if (updateClassRes.nModified != 1) {
    throw Exception('Nothing is updated.');
  }

  // Send response.
  return Response.json(body: {'event': Events.updatedClass});
}
