// import 'dart:io';

// import 'package:api/api.dart';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:tools/tools.dart';

// Future<Response> addStudents(RequestContext context, Id courseId) async {
//   // TODO: remove this

  
// // CHECK PERMISSIONS


//   await ensureIsCourseTeacher(context, courseId);

//   // EXTRACT ARGUMENTS
//   final formData = await context.formData;
//   final Iterable<Id> studentIds = toIdList(formData.fields['studentIds'])!;

//   // VALIDATE ARGUMENTS

//   // CHECK IF STUDENT IDS REALLY CORRESPOND TO STUDENTS
//   await validateUserIds(context, studentIds, UserRole.student);

//   // CHECK IF SOME STUDENT IDS ARE IN THE COURSE ALREADY
//   final studentsAlreadyInCourse = await context.db.collection('courses').count({
//     '_id': courseId,
//     'studentIds': {r'$in': studentIds}
//   });
//   if (studentsAlreadyInCourse > 0) {
//     // THERE ARE STUDENT IDS THAT ARE ALREADY IN THE COURSE
//     throw InvalidField({'studentIds': ValidationErrors.duplicated(DuplicationFields.user)});
//   }

//   // MODIFY DATA POOL
//   final addStudentResult = await context.db.collection('courses').updateOne(
//     {'_id': courseId},
//     {
//       r'$addToSet': {
//         'studentIds': {r'$each': studentIds}
//       }
//     },
//   );

//   // IF NOTHING IS MODIFIED
//   if (addStudentResult.nModified != 1) {
//     throw Exception('Nothing is modified.');
//   }

//   // SEND RESPONSE
//   return Response.json(body: {
//     'event': Events.addedStudentsToCourse,
//   });
// }
