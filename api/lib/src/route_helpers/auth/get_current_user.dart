import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// GET /auth/currentuser => `User`
Future<Response> getCurrentUser(RequestContext context) async {
  // Get current user by id.
  final userId = (await context.user).id;
  final getUserRes = await context.db.collection('users').modernFindOne(
    filter: {'_id': userId},
    projection: Projections.user,
  );
  final currentUser = getUserRes;

  // If the current userId does not correspond to a user.
  if (currentUser == null) {
    throw Unauthorized();
  }

  // Send response.
  return Response.json(body: {
    'event': Events.gotCurrentUser,
    'data': currentUser,
  });
}
