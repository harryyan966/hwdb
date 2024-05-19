import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tools/tools.dart';

class MethodNotAllowed implements Exception {}

class Unauthorized implements Exception {}

class NotFound implements Exception {
  NotFound(this.field);
  final String field;
}

class Forbidden implements Exception {
  Forbidden(this.error);
  final Errors error;
}

class BadRequest implements Exception {
  BadRequest(this.error);
  final Errors error;
}

class InvalidField implements Exception {
  InvalidField(this.data);
  final Map<String, ValidationErrors> data;
}

Middleware exceptionsHandler() {
  return (handler) {
    return (context) async {
      try {
        return await handler(context);
      } on MethodNotAllowed {
        return Response.json(statusCode: HttpStatus.methodNotAllowed, body: {
          'error': Errors.methodNotAllowed,
        });
      } on Unauthorized {
        return Response.json(statusCode: HttpStatus.unauthorized, body: {
          'error': Errors.unauthorized,
        });
      } on NotFound catch (err) {
        return Response.json(statusCode: HttpStatus.notFound, body: {
          'error': Errors.notFound,
          'data': err.field,
        });
      } on Forbidden catch (err) {
        return Response.json(statusCode: HttpStatus.forbidden, body: {
          'error': err.error,
        });
      } on BadRequest catch (err) {
        return Response.json(statusCode: HttpStatus.badRequest, body: {
          'error': err.error,
        });
      } on InvalidField catch (err) {
        return Response.json(statusCode: HttpStatus.badRequest, body: {
          'error': Errors.validationError,
          'data': err.data,
        });
      } on TypeError catch (e, s) {
        print(s.toString().split('\n').first);
        print('TYPE ERROR CAUGHT');
        rethrow;
      }
    };
  };
}
