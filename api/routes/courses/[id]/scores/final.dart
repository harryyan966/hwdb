import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.isPost) return publishFinalScores(context, toId(id));
  if (context.isPut) return generateFinalScores(context, toId(id));

  throw MethodNotAllowed();
}
