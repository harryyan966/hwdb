import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.isPost) return logOut(context);

  throw MethodNotAllowed();
}
