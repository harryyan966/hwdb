import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /users => {
///   `users: List<User>`,
///   `hasMore: bool`,
/// }
Future<Response> getUsers(RequestContext context) async {
  // Ensure the user is logged in.
  await context.user;

  // Get filter arguments.
  final qargs = context.qargs;
  final start = ParseString.toIntOrNull(qargs['start']);
  final count = ParseString.toIntOrNull(qargs['count']) ?? kSingleGetCount;
  final name = qargs['name'];
  final role = ParseString.toUserRoleOrNull(qargs['role']);

  // Construct filter.
  final filter = {
    if (name != null) 'name': {r'$regex': name, r'$options': 'i'},
    if (role != null) 'role': role.name,
  };

  final getUsersRes = await context.db
      .collection('users')
      .modernFind(
        skip: start == 0 ? null : start,
        limit: count,
        filter: filter,
        projection: Projections.user,
      )
      .toList();
  final users = getUsersRes;

  // Determine whether there are more users.
  final countUsersRes = await context.db.collection('users').modernCount(
        skip: start == 0 ? null : start,
        filter: filter,
      );
  final hasMore = countUsersRes.count > count;

  // Send Response
  return Response.json(body: {
    'event': Events.gotUsers,
    'data': {
      'users': users,
      'hasMore': hasMore,
    }
  });
}
