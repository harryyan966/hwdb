import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /classes => `void`
///
/// NOTE: The new api is not going to return the created object.
Future<Response> createClass(RequestContext context) async {
  await Ensure.isAdmin(context);

  // Get new class info.
  final formData = await context.formData;
  final name = formData.fields['name']!;
  final teacherId = ParseString.toIdOrNull(formData.fields['teacherId'])!;
  final studentIds = ParseString.toIdListOrNull(formData.fields['studentIds']);

  // Validate class info.
  Validate.className(name);

  // Ensure the class name is not duplicated in the database.
  await Ensure.classInfoNotInDb(context, name);

  // Ensure the provided teacherId corresponds to a valid teacher.
  await Ensure.isUserWithRole(context, teacherId, UserRole.teacher);

  // Ensure the provided studentIds correspond to valid students.
  if (studentIds != null) {
    await Ensure.areUsersWithRole(context, studentIds, UserRole.student);
  }

  // Save the new class.
  final insertClassRes = await context.db.collection('classes').insertOne({
    'name': name,
    'teacherId': teacherId,
    'studentIds': studentIds ?? const [],
  });
  await Ensure.hasNoWriteErrors(insertClassRes);

  // Ensure that the class is created.
  if (insertClassRes.nInserted != 1) {
    throw Exception('Nothing is created.');
  }

  // Send response.
  return Response.json(body: {'event': Events.createdClass});
}
