// final getStudentsRes = (await context.db.collection('courses').modernAggregate([
//     {
//       r'$match': {'_id': courseId}
//     },
//     {
//       r'$lookup': {
//         'from': 'users',
//         'localField': 'studentIds',
//         'foreignField': '_id',
//         'pipeline': [
//           {r'$project': Projections.user}
//         ],
//         'as': 'students',
//       }
//     },
//     {
//       r'$project': {'students': 1}
//     },
//   ]).toList());

//   if (getStudentsRes.isEmpty) {
//     throw NotFound('students');
//   }