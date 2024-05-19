// final createAssignmentResult = await context.db.collection('courses').updateOne(
//     {
//       r'$push': {
//         'assignments': {
//           r'$each': [newAssignment],
//           r'$sort': {'dueDate': -1},
//         },
//       },
//     },
//   );
//   if (createAssignmentResult.nModified != 1) {
//     throw Exception('Nothing is modified');
//   }