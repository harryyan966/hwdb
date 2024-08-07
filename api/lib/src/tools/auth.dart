import 'package:api/api.dart';
import 'package:crypt/crypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:tools/tools.dart';

abstract class AuthTools {
  AuthTools._();

  static const _secret = Env.tokenSecret;
  static const _tokenExpiresIn = Duration(days: 6);

  /// Returns a token from an id
  static String encodeToken(Id id) {
    final token = JWT({'id': id}).sign(
      SecretKey(_secret),
      expiresIn: _tokenExpiresIn,
    );
    return token;
  }

  /// Returns a password hash from a password.
  static String hashPassword(String password) {
    return Crypt.sha256(password).toString();
  }

  /// Determines whether a hash and a password match.
  static bool verifyPassword(String hash, String password) {
    return Crypt(hash).match(password);
  }

  /// Decodes JWT token to id
  static Id? _decodeToken(String? token) {
    if (token == null) {
      return null;
    }

    try {
      final payload = JWT.verify(token, SecretKey(_secret)).payload as Json;
      final id = payload['id'];
      return toId(id);
    } on Exception {
      return null;
    }
  }

  static String? _getToken(RequestContext context) {
    final authHeader = context.request.headers['Authorization']?.split(' ');

    if (authHeader == null || authHeader.length != 2 || authHeader.first != 'Bearer') {
      return null;
    }
    return authHeader.last;
  }

  static Middleware authHandler() {
    return (handler) {
      return (context) {
        final token = _getToken(context);
        final userId = _decodeToken(token);
        return handler(context.provide<Id?>(() => userId));
      };
    };
  }
}
