import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.isGet) return getScoreboard(context, toId(id));  
  // if (context.isPut) return replaceScoreboard(context, toId(id));

  throw MethodNotAllowed();
}
