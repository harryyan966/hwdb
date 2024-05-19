import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.isGet) return getCourses(context);
  if (context.isPost) return createCourse(context);

  throw MethodNotAllowed();
}
