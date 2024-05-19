import 'package:tools/tools.dart';

@immutable
class User extends Equatable {
  final String id;
  final String name;
  final UserRole role;
  final String profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.role,
    this.profileImageUrl = '',
  });

  const User.empty()
      : id = '',
        name = '',
        role = UserRole.none,
        profileImageUrl = '';

  factory User.fromJson(Json json) => json.isEmpty
      ? User.empty()
      : User(
          id: json['id'],
          name: json['name'],
          role: UserRole.values.byName(json['role']),
          profileImageUrl: json['profileImageUrl'] ?? '',
        );

  Json toJson() => isEmpty
      ? {}
      : {
          'id': id,
          'name': name,
          'role': role.name,
          'profileImageUrl': profileImageUrl,
        };

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object> get props => [id, name, role, profileImageUrl];
}
