import 'dart:async';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /classes => `List<Class>`
///
/// NOTE: The new api is not going to optimize on performance but rather optimizing on experience.
/// Specifically, lookups will be carried out before matching, skipping, and limiting to provide potentially better search results.
Future<Response> getClasses(RequestContext context) async {
  // Ensure the user exists.
  final currentUser = await context.user;

  // Get query info.
  final qargs = context.qargs;
  final start = ParseString.toIntOrNull(qargs['start']);
  final count = ParseString.toIntOrNull(qargs['count']) ?? kSingleGetCount;
  final keyword = qargs['keyword'];

  // Validate query info.
  Validate.startValue(start);
  Validate.countValue(count);

  // Construct pipeline elements.
  final relatedToCurrentUser = [
    // Get classes that are related to the current user only.
    if (currentUser.role.isNotAdmin)
      {
        r'$match': {
          '\$or': [
            {'teacherId': currentUser.id},
            {'studentIds': currentUser.id},
          ]
        }
      },
  ];

  final projectTeacherId = [
    // Get teacher info with teacherId.
    {
      r'$lookup': {
        'from': 'users',
        'localField': 'teacherId',
        'foreignField': '_id',
        'pipeline': [
          {r'$project': Projections.user}
        ],
        'as': 'teacher',
      }
    },
    // Convert `teacher` field from list to json
    {r'$unwind': r'$teacher'},
  ];

  final projectStudentIds = [
    // Get student info with studentIds.
    {
      r'$lookup': {
        'from': 'users',
        'localField': 'studentIds',
        'foreignField': '_id',
        'pipeline': [
          {r'$project': Projections.user}
        ],
        'as': 'students',
      }
    },
  ];

  final matchKeyword = [
    // Get results that contain the keyword in any way.
    if (keyword != null)
      {
        r'$match': {
          'name': {'\$regex': keyword},
          'teacher.name': {'\$regex': keyword},
          'students.name': {'\$regex': keyword},
        }
      },
  ];

  // TODO: is pagination even necessary? does this improve performance in any significant way if we have to search everything in the database anyway?
  final restrictRange = [
    if (start != null && start > 0) {r'$skip': start},
    {r'$limit': count + 1}, // TODO: a weird hack to quickly determine whether there are more classes left.
  ];

  final projectFields = [
    // Include only the required fields only.
    {r'$project': Projections.classInfo},
  ];

  // Get classes with the provided arguments.
  final getClassesRes = await context.db.collection('classes').modernAggregate([
    ...relatedToCurrentUser,
    ...projectTeacherId,
    ...projectStudentIds,
    ...matchKeyword,
    ...restrictRange,
    ...projectFields,
  ]).toList();

  // Determine whether there are more classes left.
  final hasMore = getClassesRes.length > count; // TODO: hack implemented

  // Send response.
  return Response.json(body: {
    'event': Events.gotClasses,
    'data': {
      'classes': getClassesRes.take(count),     // TODO: hack implemented
      'hasMore': hasMore,
    }
  });
}
