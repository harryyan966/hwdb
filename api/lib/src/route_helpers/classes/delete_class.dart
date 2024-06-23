import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// DELETE /classes/[classId] => `void`
///
/// NOTE: The new api is not going to return the deleted object.
Future<Response> deleteClass(RequestContext context, Id classId) async {
  await Ensure.isAdmin(context);

  // Delete the specified class.
  final deleteClassRes = await context.db.collection('classes').deleteOne({
    '_id': classId,
  });
  await Ensure.hasNoWriteErrors(deleteClassRes);

  // Ensure that a class has been deleted.
  if (deleteClassRes.nRemoved != 1) {
    throw Exception('Nothing is deleted.');
  }

  // Send response.
  return Response.json(body: {'event': Events.deletedClass});
}
