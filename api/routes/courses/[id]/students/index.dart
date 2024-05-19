import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.isGet) return getCourseStudents(context, toId(id));
  // if (context.isPut) return updateCourseStudentList(context, toId(id));
  // if (context.isPost) return addStudents(context, toId(id));

  throw MethodNotAllowed();
}
