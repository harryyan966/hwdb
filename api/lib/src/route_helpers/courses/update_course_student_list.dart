import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

@Deprecated('Use update course info instead.')
Future<Response> updateCourseStudentList(RequestContext context, Id courseId) async {
  // CHECK PERMISSIONS
  await Ensure.isAdmin(context);

  // EXTRACT ARGUMENTS
  final formData = await context.formData;
  final List<Id> studentIds = ParseString.toIdListOrNull(formData.fields['studentIds'])!;

  // VALIDATE ARGUMENTS
  await Ensure.areUsersWithRole(context, studentIds, UserRole.student);

  // MODIFY DATA POOL
  final updateStudentListResult = await context.db.collection('courses').updateOne(
    {'_id': courseId},
    {
      r'$set': {'studentIds': studentIds}
    },
  );
  if (updateStudentListResult.hasWriteErrors) {
    throw Exception('Something failed in updateStudentList');
  }

  // SEND RESPONSE
  return Response.json(body: {
    'event': Events.updatedCourseStudentList,
  });
}
