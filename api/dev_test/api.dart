import 'package:mongo_dart/mongo_dart.dart';

Future<void> main() async {
  final database = Db('mongodb://localhost:27017/hw-dashboard');
  await database.open();

  await database.collection('users').insertOne({});

  await database.close();
}
