import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id, String sid) async {
  if (context.isGet) return getStudentScore(context, toId(id), toId(sid));
  if (context.isPatch) return updateScore(context, toId(id), toId(sid));

  throw MethodNotAllowed();
}
