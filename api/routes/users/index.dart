import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.isGet) return getUsers(context);
  if (context.isPost) return createUser(context);
  if (context.isPatch) return updatePersonalInfo(context);

  throw MethodNotAllowed();
}
