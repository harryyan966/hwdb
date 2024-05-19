import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /auth/logout => `void`
Future<Response> logOut(RequestContext context) async {
  // Ensure the user exists.
  await context.user;

  // Send log-out confirmation.
  return Response.json(body: {
    'event': Events.loggedOut,
  });
}
