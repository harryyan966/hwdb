// // update course.
//   final findandmodifyres = await context.db.collection('courses').findAndModify(
//     query: {'_id': courseId},
//     update: {
//       r'$set': {
//         if (name != null) 'name': name,
//         if (grade != null) 'grade': grade.name,
//         if (year != null) 'year': year,
//         if (teacherId != null) 'teacherId': teacherId,
//         if (studentIds != null) 'studentIds': studentIds,
//       }
//     },
//     returnNew: true,
//     fields: Projections.courseInfo,
//   );

//   if (findandmodifyres == null) {
//     throw Exception('Nothing is updated');
//   }

//   final teacher = await context.db.collection('users').findOne({'_id': findandmodifyres['teacherId']});