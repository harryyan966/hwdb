import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

// CREATE A DATABASE REFERENCE
final _db = Db('mongodb://localhost:27017/hw-dashboard-prod');

// THIS FUNCTION IS ONLY CALLED WHEN THE SERVER IS OPENED
Future<void> init(InternetAddress ip, int port) async {
  await _db.open();

  // Ensure user names do not repeat.
  await _db.collection('users').createIndex(name: 'unique-user-name', keys: {'name': 1}, unique: true);

  // Ensure courses' name-grade-year combination don't repeat and speed up search on these fields
  // (i.e. this makes sure not ALL of them are the same (some of them can be the same))
  await _db
      .collection('courses')
      .createIndex(name: 'unique-course-name', keys: {'name': 1, 'grade': 1, 'year': 1}, unique: true);

  // Ensure text search ability by user name.
  // (text search enables searching by word (eg. 'how are you' could be matched by 'how you'))
  await _db.collection('users').createIndex(name: 'name-text', keys: {'name': 'text'});

  // Ensure text search ability by course name.
  await _db.collection('courses').createIndex(name: 'name-text', keys: {'name': 'text'});

  // Ensure assignments are sorted properly.
  await _db
      .collection('courses')
      .createIndex(name: 'assignments', keys: {'assignments.dueDate': -1, 'assignments.name': 1});
}

// THIS FUNCTION IS CALLED EVERYTIME THE SERVER IS RELOADED
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  final chain = Platform.script.resolve('certificates/server_chain.pem').toFilePath();
  final key = Platform.script.resolve('certificates/server_key.pem').toFilePath();

  final securityContext = SecurityContext()
    ..useCertificateChain(chain)
    ..usePrivateKey(key, password: Env.privateKeyPassword);

  return serve(
    handler

        // HANDLE EXCEPTIONS
        .use(exceptionsHandler())

        // LOG ALL REQUESTS IN THE CONSOLE
        .use(requestLogger())

        // IDENTIFY THE USER CURRENTLY LOGGED IN
        .use(AuthTools.authHandler())

        // PROVIDE THE DATABASE
        .use(provider((_) => _db)),
    ip,
    port,
    securityContext: securityContext,
  );
}
