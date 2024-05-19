import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'edit_user_state.dart';

class EditUserCubit extends Cubit<EditUserState> {
  EditUserCubit({
    required HwdbHttpClient httpClient,
    required this.user,
  })  : _httpClient = httpClient,
        super(const EditUserState());

  final HwdbHttpClient _httpClient;
  final User user;

  Future<void> editUser({
    String? name,
    String? oldPassword,
    String? newPassword,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // REQUEST TO UPDATE USER INFO
    final res = await _httpClient.patch('users/${user.id}', args: {
      'name': name,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });

    // IF THE USER IS UPDATED SUCCESSFULLY
    if (Events.updatedUser.matches(res['event'])) {
      final newUser = User.fromJson(res['data']);
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.updatedUser,
        newUser: newUser,
      ));
    }

    // IF THERE IS A FIELD VALIDATION ERROR
    else if (Errors.validationError.matches(res['error'])) {
      final validationError = toValidationError(res['data']);
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.validationError,
        validationError: validationError,
      ));
    }

    // THROW THE UNEXPECTED RESPONSE
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
