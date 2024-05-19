import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'user_search_state.dart';

class UserSearchCubit extends Cubit<UserSearchState> {
  UserSearchCubit({
    required HwdbHttpClient httpClient,
  })  : _httpClient = httpClient,
        super(const UserSearchState());

  final HwdbHttpClient _httpClient;

  static const kLoadCount = 20;

  Future<void> getUsers() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // DO NOTHING IF THERE ARE NO MORE COURSES
    if (!state.hasMore) {
      return;
    }

    // GET USERS FROM API
    final res = await _httpClient.get('users', {
      'start': state.users.length,
      'count': kLoadCount,
      if (state.keyword.isNotEmpty) 'name': state.keyword,
      if (state.role.isNotEmpty) 'role': state.role,
    });

    // IF THE USERS ARE GOT SUCCESSFULLY
    if (Events.gotUsers.matches(res['event'])) {
      final List<User> newUsers = ConversionTools.toJsonTypeList(res['data']['users'], User.fromJson);
      final bool hasMore = res['data']['hasMore'];
      emit(state.copyWith(
        status: PageStatus.good,
        users: [...state.users, ...newUsers],
        hasMore: hasMore,
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  Future<void> searchUsers({String? keyword, UserRole? role}) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // Update keyword and role.
    emit(state.copyWith(
      keyword: keyword,
      role: role,
    ));

    // GET USERS FROM API
    final res = await _httpClient.get('users', {
      'count': kLoadCount,
      if (state.keyword.isNotEmpty) 'name': state.keyword,
      if (state.role.isNotEmpty) 'role': state.role.name,
    });

    // IF THE USERS ARE GOT SUCCESSFULLY
    if (Events.gotUsers.matches(res['event'])) {
      final List<User> newUsers = ConversionTools.toJsonTypeList(res['data']['users'], User.fromJson);
      final bool hasMore = res['data']['hasMore'];
      emit(state.copyWith(
        status: PageStatus.good,
        users: newUsers,
        hasMore: hasMore,
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  Future<void> reLoad() async {
    await searchUsers();
  }

  Future<void> deleteUser(String id) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // DELETE USER FROM API
    final res = await _httpClient.delete('users/$id');

    // IF THE USER IS DELETED SUCCESSFULLY
    if (Events.deletedUser.matches(res['event'])) {
      // DIRECTLY UPDATE LOCAL DATA
      emit(state.copyWith(
        status: PageStatus.good,
        users: state.users.where((e) => e.id != id).toList(),
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
