import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id, String aid) async {
  if (context.isPatch) return updateAssignment(context, toId(id), toId(aid));
  if (context.isDelete) return deleteAssignment(context, toId(id), toId(aid));

  throw MethodNotAllowed();
}
