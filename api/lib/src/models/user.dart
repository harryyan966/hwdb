import 'package:api/api.dart';
import 'package:tools/tools.dart';

class UserInfo {
  final Id id;
  final String name;
  final UserRole role;
  final String password;

  const UserInfo({
    required this.id,
    required this.name,
    required this.role,
    required this.password,
  });

  factory UserInfo.fromJson(Json json) => UserInfo(
        id: json['id'],
        name: json['name'],
        role: ParseString.toUserRoleOrNull(json['role'])!,
        password: json['password'],
      );
}
