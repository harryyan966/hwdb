import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id, String sid) async {
  // if (context.isDelete) return removeStudent(context, toId(id), toId(sid));

  throw MethodNotAllowed();
}
