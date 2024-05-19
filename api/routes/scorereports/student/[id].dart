import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.isGet) return getStudentScoreReport(context, toId(id));

  throw MethodNotAllowed();
}
