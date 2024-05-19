import 'dart:convert';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:tools/tools.dart';

extension ContextX on RequestContext {
  bool get isGet => request.method == HttpMethod.get;
  bool get isPost => request.method == HttpMethod.post;
  bool get isPut => request.method == HttpMethod.put;
  bool get isPatch => request.method == HttpMethod.patch;
  bool get isDelete => request.method == HttpMethod.delete;

  /// Database.
  Db get db => read<Db>();

  /// Current user.
  Future<UserInfo> get user async {
    final res = await userOrNull;
    if (res == null) throw Unauthorized();
    return res;
  }

  /// Current user or guest.
  Future<UserInfo?> get userOrNull async {
    final userId = read<Id?>();
    if (userId == null) {
      return null;
    }

    // GET USER FROM DATABASE
    final user = await db.collection('users').modernFindOne(
      filter: {'_id': userId},
      projection: Projections.fullUser,
    );
    if (user == null) return null;

    return UserInfo(
      id: userId,
      name: user['name'],
      role: ParseString.toUserRoleOrNull(user['role'])!,
      password: user['password'],
    );
  }

  /// Query parameters.
  Map<String, String> get qargs {
    return request.uri.queryParameters;
  }

  /// Request body.
  @Deprecated('Use formdata instead.')
  Future<Json> get body async {
    return jsonDecode(await request.body());
  }

  /// Formdata body.
  Future<FormData> get formData async {
    return await request.formData();
  }
}
