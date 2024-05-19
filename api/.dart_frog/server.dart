// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../main.dart' as entrypoint;
import '../routes/index.dart' as index;
import '../routes/users/index.dart' as users_index;
import '../routes/users/[id]/index.dart' as users_$id_index;
import '../routes/scorereports/student/[id].dart' as scorereports_student_$id;
import '../routes/courses/index.dart' as courses_index;
import '../routes/courses/[id]/index.dart' as courses_$id_index;
import '../routes/courses/[id]/students/index.dart' as courses_$id_students_index;
import '../routes/courses/[id]/students/[sid].dart' as courses_$id_students_$sid;
import '../routes/courses/[id]/scores/midterm.dart' as courses_$id_scores_midterm;
import '../routes/courses/[id]/scores/index.dart' as courses_$id_scores_index;
import '../routes/courses/[id]/scores/final.dart' as courses_$id_scores_final;
import '../routes/courses/[id]/scores/student/[sid]/index.dart' as courses_$id_scores_student_$sid_index;
import '../routes/courses/[id]/scores/student/[sid]/final.dart' as courses_$id_scores_student_$sid_final;
import '../routes/courses/[id]/assignments/index.dart' as courses_$id_assignments_index;
import '../routes/courses/[id]/assignments/[aid].dart' as courses_$id_assignments_$aid;
import '../routes/auth/logout.dart' as auth_logout;
import '../routes/auth/login.dart' as auth_login;
import '../routes/auth/currentuser.dart' as auth_currentuser;


void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  await entrypoint.init(address, port);
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return entrypoint.run(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..mount('/auth', (context) => buildAuthHandler()(context))
    ..mount('/courses/<id>/assignments', (context,id,) => buildCourses$idAssignmentsHandler(id,)(context))
    ..mount('/courses/<id>/scores/student/<sid>', (context,id,sid,) => buildCourses$idScoresStudent$sidHandler(id,sid,)(context))
    ..mount('/courses/<id>/scores', (context,id,) => buildCourses$idScoresHandler(id,)(context))
    ..mount('/courses/<id>/students', (context,id,) => buildCourses$idStudentsHandler(id,)(context))
    ..mount('/courses/<id>', (context,id,) => buildCourses$idHandler(id,)(context))
    ..mount('/courses', (context) => buildCoursesHandler()(context))
    ..mount('/scorereports/student', (context) => buildScorereportsStudentHandler()(context))
    ..mount('/users/<id>', (context,id,) => buildUsers$idHandler(id,)(context))
    ..mount('/users', (context) => buildUsersHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/logout', (context) => auth_logout.onRequest(context,))..all('/login', (context) => auth_login.onRequest(context,))..all('/currentuser', (context) => auth_currentuser.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildCourses$idAssignmentsHandler(String id,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => courses_$id_assignments_index.onRequest(context,id,))..all('/<aid>', (context,aid,) => courses_$id_assignments_$aid.onRequest(context,id,aid,));
  return pipeline.addHandler(router);
}

Handler buildCourses$idScoresStudent$sidHandler(String id,String sid,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => courses_$id_scores_student_$sid_index.onRequest(context,id,sid,))..all('/final', (context) => courses_$id_scores_student_$sid_final.onRequest(context,id,sid,));
  return pipeline.addHandler(router);
}

Handler buildCourses$idScoresHandler(String id,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/midterm', (context) => courses_$id_scores_midterm.onRequest(context,id,))..all('/', (context) => courses_$id_scores_index.onRequest(context,id,))..all('/final', (context) => courses_$id_scores_final.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildCourses$idStudentsHandler(String id,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => courses_$id_students_index.onRequest(context,id,))..all('/<sid>', (context,sid,) => courses_$id_students_$sid.onRequest(context,id,sid,));
  return pipeline.addHandler(router);
}

Handler buildCourses$idHandler(String id,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => courses_$id_index.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildCoursesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => courses_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildScorereportsStudentHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<id>', (context,id,) => scorereports_student_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildUsers$idHandler(String id,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => users_$id_index.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildUsersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => users_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

