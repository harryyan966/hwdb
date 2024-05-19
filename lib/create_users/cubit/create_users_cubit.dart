import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'create_users_state.dart';

class CreateUsersCubit extends Cubit<CreateUsersState> {
  CreateUsersCubit({
    required HwdbHttpClient httpClient,
  })  : _httpClient = httpClient,
        super(const CreateUsersState());

  final HwdbHttpClient _httpClient;

  Future<void> createUser({
    required String name,
    required String password,
    required UserRole role,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // CREATE THE USER IN THE SERVER
    final res = await _httpClient.post('users', args: {
      'name': name,
      'password': password,
      'role': role.name,
    });

    // IF THE USER IS CREATED SUCCESSFULLY
    if (Events.createdUser.matches(res['event'])) {
      final User newUser = User.fromJson(res['data']);

      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.createdUser,
        createdUsers: [newUser, ...state.createdUsers],
      ));
    }

    // IF THE SERVER THREW A VALIDATION ERROR
    else if (Errors.validationError.matches(res['error'])) {
      final validationError = toValidationError(res['data']);

      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.validationError,
        validationError: validationError,
      ));
    }

    // THROW ANY UNEXPECTED RESULTS
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  Future<void> deleteUser(String id) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // DELETE USER FROM API
    final res = await _httpClient.delete('users/$id');

    // IF THE USER IS DELETED SUCCESSFULLY
    if (Events.deletedUser.matches(res['event'])) {
      // DIRECTLY UPDATE LOCAL DATA
      // TODO: will this work? (especially in select)
      emit(state.copyWith(
        status: PageStatus.good,
        createdUsers: state.createdUsers.where((e) => e.id != id).toList(),
      ));
    }

    // THROW ANY UNEXPECTED ERROR
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
