import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /users => `User`
Future<Response> createUser(RequestContext context) async {
  await Ensure.isAdmin(context);

  // Get new user info.
  final formData = await context.formData;
  final name = formData.fields['name']!;
  final password = formData.fields['password']!;
  final role = ParseString.toUserRoleOrNull(formData.fields['role'])!;
  final profileImage = formData.files['profileImage'];

  // Validate user info.
  Validate.userName(name);
  Validate.userPassword(password);

  // Ensure there are no duplicate user names.
  await Ensure.userNameNotInDb(context, name);

  // Save profile image (if present).
  final profileImageUrl = profileImage == null ? null : await FileTools.saveImage(profileImage);

  // Calculate password hash.
  final passwordHash = AuthTools.hashPassword(password);

  // Write the user in the database.
  final createUserRes = await context.db.collection('users').insertOne({
    'name': name,
    'password': passwordHash,
    'role': role.name,
    'profileImageUrl': profileImageUrl,
  });

  await Ensure.hasNoWriteErrors(createUserRes);

  if (createUserRes.nInserted != 1) {
    throw Exception('Nothing was created.');
  }

  // Get user info to be sent back to the client.
  final getNewUserRes = await context.db.collection('users').modernFindOne(
    filter: {'_id': createUserRes.id},
    projection: Projections.user,
  );
  final newUser = getNewUserRes;

  if (newUser == null) {
    throw NotFound('new user');
  }

  // Send response.
  return Response.json(body: {
    'event': Events.createdUser,
    'data': newUser,
  });
}
