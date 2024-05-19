import 'package:mongo_dart/mongo_dart.dart';

typedef Id = ObjectId;

Id newId() {
  return ObjectId();
}

Id toId(String id) {
  return ObjectId.fromHexString(id);
}

String fromId(Id id) {
  return id.oid;
}
