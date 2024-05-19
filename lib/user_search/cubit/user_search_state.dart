part of 'user_search_cubit.dart';

@immutable
class UserSearchState extends Equatable {
  final PageStatus status;
  final List<User> users;
  final bool hasMore;
  final String keyword;
  final UserRole role;

  const UserSearchState({
    this.status = PageStatus.good,
    this.users = const [],
    this.hasMore = true,
    this.keyword = '',
    this.role = UserRole.none,
  });

  UserSearchState copyWith({
    PageStatus? status,
    List<User>? users,
    bool? hasMore,
    String? keyword,
    UserRole? role,
  }) {
    return UserSearchState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasMore: hasMore ?? this.hasMore,
      keyword: keyword ?? this.keyword,
      role: role ?? this.role,
    );
  }

  @override
  List<Object> get props => [status, users, hasMore, keyword, role];
}
