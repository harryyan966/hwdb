import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// PATCH /users => `User`
Future<Response> updatePersonalInfo(RequestContext context) async {
  // Get the current user id.
  final currentUser = await context.user;

  // Get new user info.
  final formData = await context.formData;
  final name = formData.fields['name'];
  final oldPassword = formData.fields['oldPassword'];
  final newPassword = formData.fields['newPassword'];
  final profileImage = formData.files['profileImage'];

  // Ensure there is something being updated.
  if (name == null && newPassword == null && profileImage == null) {
    throw BadRequest(Errors.emptyRequest);
  }

  // If the user is allowed to edit his user name.
  if (currentUser.role.isNotStudent) {
    // Ensure new user name is valid and does not exist in the database.
    Validate.userName(name);
    await Ensure.userNameNotInDb(context, name);
  }

  if (newPassword != null) {
    // Ensure an old password is provided.
    if (oldPassword == null) {
      throw InvalidField({'oldPassword': ValidationErrors.fieldRequired()});
    }

    // Validate new password.
    Validate.userPassword(newPassword);

    // Ensure the old password is not the same as the new password.
    if (newPassword == oldPassword) {
      throw InvalidField({'newPassword': ValidationErrors.samePasswords()});
    }

    // Ensure the old password is correct.
    final matchedUsers = await context.db.collection('users').count({
      '_id': currentUser.id,
      'password': oldPassword,
    });
    if (matchedUsers != 1) {
      throw InvalidField({'oldPassword': ValidationErrors.invalidPassword()});
    }
  }

  // Save profile image and get its url.
  final profileImageUrl = profileImage == null ? null : await FileTools.saveImage(profileImage);

  // Update the current user in the database.
  final updateUserRes = await context.db.collection('users').updateOne(
    {'_id': currentUser.id},
    {
      '\$set': {
        if (currentUser.role.isNotStudent && name != null) 'name': name,
        if (newPassword != null) 'password': newPassword,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      }
    },
  );

  await Ensure.hasNoWriteErrors(updateUserRes);

  if (updateUserRes.nModified == 0) {
    throw Exception('Nothing was modified.');
  }

  // Get the updated user.
  final newUser = await context.db.collection('users').modernFindOne(
    filter: {'_id': currentUser.id},
    projection: Projections.user,
  );

  // Send new user info.
  return Response.json(body: {
    'event': Events.updatedUser,
    'data': newUser,
  });
}
