import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /users/[userId] => `User`
Future<Response> updateUser(RequestContext context, Id userId) async {
  await Ensure.isAdmin(context);

  // Get new user info.
  final formData = await context.formData;
  final name = formData.fields['name'];
  final role = formData.fields['role'];

  // Ensure there is something being updated.
  if (name == null && role == null) {
    throw BadRequest(Errors.emptyRequest);
  }

  // Ensure new user name is valid and does not exist in the database.
  Validate.userName(name);
  await Ensure.userNameNotInDb(context, name);

  // Update user in the database.
  final updateUserRes = await context.db.collection('users').updateOne(
    {'_id': userId},
    {
      r'$set': {
        if (name != null) 'name': name,
        if (role != null) 'role': role,
      },
    },
  );

  await Ensure.hasNoWriteErrors(updateUserRes);

  if (updateUserRes.nModified != 1) {
    throw Exception('Nothing is modified.');
  }

  // Get the new user.
  final getNewUserRes = await context.db.collection('users').modernFindOne(
    filter: {'_id': userId},
    projection: Projections.user,
  );
  final newUser = getNewUserRes;

  if (newUser == null) {
    throw NotFound('user');
  }

  // Send new user info.
  return Response.json(body: {
    'event': Events.updatedUser,
    'data': newUser,
  });
}
