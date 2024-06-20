import 'package:api/api.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:tools/tools.dart';

Future<void> main() async {
  final database = Db('mongodb://localhost:27017/hw-dashboard');
  await database.open();

  // final result = await database.collection('users').find().toList();

  final courseId = toId('662f8c6378e4bf0258000000');
  final name = 'NEW COURSE';
  final grade = Grade.g10fall.name;
  final year = 2000;
  final teacherId = newId();

  final res = await database.collection('courses').modernAggregate([
    {'updateOne': {'filter': {'_id': id},'update': {'\$set': {''}}}}
  ])

  // final result = await database.collection('courses').insertOne({
  //   'name': name,
  //   'grade': grade,
  //   'year': year,
  //   'teacherId': teacherId,
  // });

  // final result = await database.collection('courses').updateOne(
  //   {'_id': courseId},
  //   {
  //     r'$push': {
  //       'assignments': {
  //         r'$each': [
  //           {
  //             'id': newId(),
  //             'name': 'ASSIGNMENT 4',
  //             'type': 'homework',
  //             'dueDate': DateTime.now(),
  //           }
  //         ],
  //         r'$sort': {'dueDate': 1},
  //       },
  //     },
  //   },
  // );
  // print(result.nModified);

  // final rawAssignmentNames = await database.collection('courses').modernFindOne(
  //   filter: {'_id': courseId},
  //   projection: {
  //     '_id': 0,
  //     'assignments': {'name': 1}
  //   },
  // );
  // final assignmentNames = rawAssignmentNames!['assignments'].map((e) => e['name']);
  // print(assignmentNames);

  // final res3 = await database.collection('courses').modernCount(filter: {
  //   '_id': courseId,
  //   // this will be true if any db studentId are in the provided studentIds
  //   'studentIds': {
  //     r'$all': [
  //       toId('65fc0269e4c0489580000000'),
  //       toId('65fc0280e4c0499580000000'),
  //     ]
  //   },
  //   'assignments.id': {
  //     r'$all': [
  //       toId('66361d4560a02b5893000000'),
  //     ],
  //   }
  // });
  // print(res3.count);
  // print(res3.operationTime);

  //

  // final result = await database.collection('courses').findAndModify(
  //   query: {'_id': courseId},
  //   update: {
  //     r'$set': {
  //       if (name != null) 'name': 'NEW NEW COURSE',
  //       if (grade != null) 'grade': grade,
  //       if (year != null) 'year': year,
  //       if (teacherId != null) 'teacherId': teacherId,
  //     }
  //   },
  //   returnNew: true,
  //   fields: courseInfoProjection,
  // );
  // print(result);

  // ANOTHER WAY TO UPDATE ASSIGNMENTS

  // final res = await database.collection('courses').updateOne(
  //   {
  //     '_id': courseId,
  //     'assignments.name': 'NEW ASSIGNMENT',
  //   },
  //   {
  //     r'$set': {
  //       r'assignments.$.id': newId(),
  //       r'assignments.$.dueDate': DateTime.now(),
  //     },
  //     r'sort': {
  //       'assignments': {
  //         'dueDate': -1,
  //       }
  //     }
  //   },
  // );
  // print(res.nModified);

  // UPDATE AND SORT ASSIGNMENTS

  // final res = await database.collection('courses').updateOne(
  //   {'_id': courseId},
  //   {
  //     // r'$set': {r'assignments.$[assignment].dueDate': DateTime(2024, 6, 1)},
  //     r'$push': {
  //       'assignments': {
  //         r'$each': [],
  //         r'$sort': {
  //           'dueDate': -1,
  //           'name': 1,
  //         },
  //       }
  //     },
  //   },
  //   // arrayFilters: [
  //   //   {'assignment.name': 'a3'}
  //   // ],
  // );
  // print(res.nModified);

  // if (res3.count > 0) {
  //   // THERE ARE STUDENT IDS THAT ARE ALREADY IN THE COURSE
  //   throw BadRequest(Errors.invalidArguments);
  // }

  // UPDATE COURSE INFO

  // final result = await database.collection('courses').findAndModify(
  //   query: {'_id': courseId},
  //   update: {
  //     r'$set': {
  //       if (name != null) 'name': name,
  //       if (year != null) 'year': year,
  //       if (teacherId != null) 'teacherId': teacherId,
  //     }
  //   },
  //   returnNew: true,
  //   fields: courseInfoProjection,
  // );
  // print(result);

  // UPDATE SCOREBOARD

  // final result = await database.collection('courses').updateOne(
  //   {
  //     '_id': courseId,
  //   },
  //   {
  //     r'$set': {
  //       'scores': {
  //         '65fc0269e4c0489580000000': {
  //           '6631f856ca4482946d000000': 90,
  //           '6631c0654ac7ca5dc3000000': 99,
  //           '6631c051e0185bb93d000000': 100,
  //         },
  //         '65fc0280e4c0499580000000': {
  //           '6631f856ca4482946d000000': 90,
  //           '6631c0654ac7ca5dc3000000': 99,
  //           '6631c051e0185bb93d000000': 100,
  //         },
  //         '6628d54e3d6a639f21000000': {
  //           '6631f856ca4482946d000000': 90,
  //           '6631c0654ac7ca5dc3000000': 99,
  //           '6631c051e0185bb93d000000': 100,
  //         },
  //       },
  //     }
  //   },
  // );
  // print(result.nModified);

  // GET STUDENT SCOREBOARD

  // final studentId = toId('65fc0269e4c0489580000000');
  // final result = await database.collection('courses').modernFindOne(
  //   filter: {'_id': courseId},
  //   projection: {
  //     'scores.asdlkfajsdf': 1,
  //   },
  // );
  // print(result?.pretty());

  // UPDATE SCORE

  // final studentId = toId('65fc0269e4c0489580000000');
  // final assignmentId = toId('6631f856ca4482946d000000');
  // final score = null;

  // final result = await database.collection('courses').updateOne({
  //   '_id': courseId
  // }, {
  //   r'$set': {
  //     'scores.${fromId(studentId)}.${fromId(assignmentId)}': score,
  //   }
  // });
  // print(result.nModified);

  // final result = await database.collection('courses').modernFind(
  //   filter: {
  //     '_id': courseId,
  //   },
  //   projection: {
  //     '_id': 0,
  //     'id': r'$_id',
  //     'assignments.id': 1,
  //     'assignments.name': 1,
  //   },
  // ).toList();
  // print(jsonEncode(result));

  // final result = await database.collection('courses').count({
  //   '_id': courseId,
  //   'assignments.id': toId('6631f856ca4482946d000000'),
  // });
  // print(result);

  // final updateFinalScoreResult = await database.collection('finalScores').updateOne(
  //   {'_id': courseId},
  //   {
  //     r'$set': {'finalScores': {}}
  //   },
  //   upsert: true,
  // );

  // final res = await database.collection('assignments').insertOne({
  //   'name': 'Assignment 1',
  //   'type': 'homework',
  //   'dueDate': DateTime(2024, 5, 4).toIso8601String(),
  // });
  // print(res.nInserted);

  // final res = await database.collection('assignments').find().toList();
  // print(res);
  // // print(res.pretty());
  // print(res[0]['dueDate']);

  // final c = await database.collection('courses').modernAggregate([
  //   {
  //     r'$match': {'_id': courseId}
  //   },
  //   {
  //     r'$lookup': {
  //       'from': 'users',
  //       'localField': 'teacherId',
  //       'foreignField': '_id',
  //       'as': 'teacher',
  //     }
  //   },
  //   {r'$unwind': r'$teacher'},
  //   {r'$project': projections.courseInfo},
  // ]).toList();
  // print(c);

  // final deleteAssignmentResult = await database.collection('courses').updateOne(
  //   {'_id': courseId},
  //   {
  //     r'$pull': {
  //       'assignments': {'id': toId('6631c0654ac7ca5dc3000000')},
  //     },
  //     r'$unset': {'scores.\$[studentId].${'6631c0654ac7ca5dc3000000'}': ''}
  //   },
  //   arrayFilters: [
  //     {'studentId': true}
  //   ],
  // );
  // print(deleteAssignmentResult.nModified);
  // print(deleteAssignmentResult.hasWriteErrors);
  // print(deleteAssignmentResult.writeError?.errmsg);

  final updateScoreResult = await database.collection('courses').modernAggregate([
    {r'$unwind': r'$scores'},
    {
      r'$group': {
        '_id': {
          'studentId': r'$scores.studentId',
          'assignmentId': r'$scores.assignmentId',
        },
        'score': {r'$first': r'$scores.score'}
      }
    },
    {
      r'$group': {
        '_id': r'$_id.studentId',
        'scores': {
          r'$push': {'assignmentId': r'$_id.assignmentId', 'score': r'$score'}
        }
      }
    },
    {
      r'$project': {'_id': 0, 'studentId': r'$_id', 'scores': 1}
    }
  ]).toList();

  await database.close();
}
