import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.isPatch) return updateUser(context, toId(id));
  if (context.isDelete) return deleteUser(context, toId(id));

  throw MethodNotAllowed();
}
