import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// DELETE /users/[userId] => `void`
Future<Response> deleteUser(RequestContext context, Id userId) async {
  await Ensure.isAdmin(context);

  // Delete user from the database.
  final deleteUserRes = await context.db.collection('users').deleteOne({'_id': userId});

  await Ensure.hasNoWriteErrors(deleteUserRes);

  if (deleteUserRes.nRemoved != 1) {
    throw Exception('Nothing was deleted.');
  }

  // TODO: cascade delete ??

  // Send response.
  return Response.json(body: {
    'event': Events.deletedUser,
  });
}
