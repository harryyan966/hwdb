import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// DELETE /users/[userId] => `void`
Future<Response> deleteUser(RequestContext context, Id userId) async {
  await Ensure.isAdmin(context);

  // Get info of the user to be deleted.
  final getDeletedUserRes = await context.db.collection('users').modernFindOne(
    filter: {'_id': userId},
    projection: Projections.user,
  );
  if (getDeletedUserRes == null) {
    throw NotFound('user');
  }

  final deletedUser = UserInfo.fromJson(getDeletedUserRes);

  // Ensure that admins are not deleting other admins.
  if (deletedUser.role.isAdmin && deletedUser.id != (await context.user).id) {
    throw Forbidden(Errors.permissionDenied);
  }

  // Delete user from the database.
  final deleteUserRes = await context.db.collection('users').deleteOne({'_id': userId});

  await Ensure.hasNoWriteErrors(deleteUserRes);

  if (deleteUserRes.nRemoved != 1) {
    throw Exception('Nothing was deleted.');
  }

  // If the deleted user is a student
  if (deletedUser.role.isStudent) {
    // Delete this student from every course
    final deleteStudentRes = await context.db.collection('courses').updateMany(
      {'studentIds': deletedUser.id},
      {
        '\$pull': {'studentIds': deletedUser.id}
      },
    );
    Ensure.hasNoWriteErrors(deleteStudentRes);
  }

  // If the deleted user is a teacher
  if (deletedUser.role.isTeacher) {
    // Delete every course of this teacher.
    final deleteTeacherCourseRes = await context.db.collection('courses').deleteMany(
      {'teacherId': deletedUser.id},
    );
    Ensure.hasNoWriteErrors(deleteTeacherCourseRes);
  }

  // Send response.
  return Response.json(body: {
    'event': Events.deletedUser,
  });
}
