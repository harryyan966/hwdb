import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

/// POST /auth/login => `User` + `authToken`
Future<Response> logIn(RequestContext context) async {
  // Get the amount of login attempts the user has made.
  final getLoginsRes = await context.db.collection('logins').findOne({
    'ip': context.request.connectionInfo.remoteAddress.address,
  });
  final lastAttemptTime = (getLoginsRes?['lastAttemptTime']) as DateTime?;
  final retryCount = (getLoginsRes?['retryCount'] ?? 0) as int;

  // Ensure the user is not being banned from logging in.
  // final banDuration = switch (retryCount) {
  //   0 => Duration.zero,
  //   1 => Duration.zero,
  //   2 => Duration.zero,
  //   3 => Duration(seconds: 10),
  //   4 => Duration(minutes: 1),
  //   5 => Duration(minutes: 3),
  //   6 => Duration(minutes: 30),
  //   7 => Duration(hours: 2),
  //   8 => Duration(hours: 8),
  //   int() => Duration(days: 10000),
  // };
  // final nextAttemptTime = lastAttemptTime?.add(banDuration);
  // if (getLoginsRes != null && nextAttemptTime!.isAfter(DateTime.now())) {
  //   return Response.json(
  //     statusCode: 403, // forbidden
  //     body: {
  //       'error': Errors.loginBanned,
  //       'data': nextAttemptTime,
  //     },
  //   );
  // }

  // Get credentials.
  final formData = await context.formData;
  final username = formData.fields['username']!;
  final password = formData.fields['password']!;

  // Get user with provided user name.
  final getUserRes = await context.db.collection('users').modernFindOne(
    filter: {'name': username},
    projection: Projections.fullUser,
  );
  final user = getUserRes;

  // If such user does not exist.
  if (user == null) {
    await _recordFailedLogin(context, retryCount);
    throw Forbidden(Errors.invalidCredentials);
  }

  // Ensure the password is correct.
  final actualPassword = user['password'];
  if (actualPassword != password) {
    await _recordFailedLogin(context, retryCount);
    throw Forbidden(Errors.invalidCredentials);
  }

  // Update login allowance.
  await _updateLoginAllowance(context);

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

Future<void> _recordFailedLogin(RequestContext context, int retryCount) async {
  final updateLoginsRes = await context.db.collection('logins').updateOne(
    {'ip': context.request.connectionInfo.remoteAddress.address},
    {
      '\$set': {
        'lastAttemptTime': DateTime.now(),
        'retryCount': retryCount + 1,
      },
    },
    upsert: true,
  );

  await Ensure.hasNoWriteErrors(updateLoginsRes);
}

Future<void> _updateLoginAllowance(RequestContext context) async {
  final updateLoginsRes = await context.db.collection('logins').updateOne(
    {'ip': context.request.connectionInfo.remoteAddress.address},
    {
      '\$set': {
        'lastAttemptTime': DateTime.now(),
        'retryCount': 0,
      },
    },
    upsert: true,
  );

  await Ensure.hasNoWriteErrors(updateLoginsRes);
}
