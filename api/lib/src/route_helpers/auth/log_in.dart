import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /auth/login => `User` + `authToken`
Future<Response> logIn(RequestContext context) async {
  // Get credentials.
  final formData = await context.formData;
  final username = formData.fields['username']!;
  final password = formData.fields['password']!;

  // Ensure the user is not spamming login requests.
  print(context.request.connectionInfo.remoteAddress);

  // Get user with provided user name.
  final getUserRes = await context.db.collection('users').modernFindOne(
    filter: {'name': username},
    projection: Projections.fullUser,
  );
  final user = getUserRes;

  // If such user does not exist.
  if (user == null) {
    throw Forbidden(Errors.invalidCredentials);
  }

  // Ensure the password is correct.
  final actualPassword = user['password'];
  if (actualPassword != password) {
    throw Forbidden(Errors.invalidCredentials);
  }

  // Construct auth token.
  final userId = user['id'];
  final String token = AuthTools.encodeToken(userId);

  // Construct user.
  final userInfo = {
    'id': fromId(userId),
    'name': user['name'],
    'role': user['role'],
    'profileImageUrl': user['profileImageUrl'],
  };

  // Send response.
  return Response.json(body: {
    'event': Events.loggedIn,
    'token': token,
    'data': userInfo,
  });
}
