// import 'dart:io';

// import 'package:api/api.dart';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:tools/tools.dart';

// Future<Response> removeStudent(RequestContext context, Id courseId, Id studentId) async {
//   // TODO: remove this

//   // CHECK PERMISSIONS
//   await ensureIsCourseTeacher(context, courseId);

//   // MODIFY DATA POOL
//   await context.db.collection('courses').updateOne(
//     {'_id': courseId},
//     {
//       r'$pull': {'studentIds': studentId}
//     },
//   );

//   return Response.json(body: {
//     'event': Events.removedStudentFromCourse,
//   });
// }
