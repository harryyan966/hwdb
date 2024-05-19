import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.isPatch) return updateCourseInfo(context, toId(id));
  if (context.isDelete) return deleteCourse(context, toId(id));

  throw MethodNotAllowed();
}
