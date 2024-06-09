import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required HwdbHttpClient httpClient,
  })  : _httpClient = httpClient,
        super(const LoginState());

  final HwdbHttpClient _httpClient;

  Future<void> tryGetUser() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    try {
      // TRY REQUESTING CURRENT USER
      final res = await _httpClient.get('auth/currentuser');

      // IF THE REQUEST IS SUCCESSFUL
      if (Events.gotCurrentUser.matches(res['event'])) {
        emit(state.copyWith(
          status: PageStatus.good,
          event: Events.gotCurrentUser,
          user: User.fromJson(res['data']),
        ));
      }

      else if (Errors.unauthorized.matches(res['event'])) {
        emit(state.copyWith(
          status: PageStatus.good,
          error: Errors.unauthorized,
        ));
      }

      // THROW THE UNEXPECTED RESULT
      else {
        emit(state.copyWith(status: PageStatus.bad));
        throw Exception(res.pretty());
      }
    } on SessionExpiredFailure {
      emit(state.copyWith(status: PageStatus.good));
    }
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // REQUEST TO LOG IN
    final res = await _httpClient.post('auth/login', args: {
      'username': username,
      'password': password,
    });

    // IF THE REQUEST IS SUCCESSFUL
    if (Events.loggedIn.matches(res['event'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.loggedIn,
        user: User.fromJson(res['data']),
      ));
    }

    // IF THE SERVER THREW A VALIDATION ERROR
    else if (Errors.validationError.matches(res['error'])) {
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.validationError,
        validationError: toValidationError(res['data']),
      ));
    }

    // IF THE SERVER SAID YOU HAD INVALID CREDENTIALS
    else if (Errors.invalidCredentials.matches(res['error'])) {
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.invalidCredentials,
        validationError: const {},
      ));
    }

    // IF THE SERVER BANNED YOU FROM LOGGING IN
    else if (Errors.loginBanned.matches(res['error'])) {
      emit(state.copyWith(
        status: PageStatus.bad,
        error: Errors.loginBanned,
        validationError: const {},
      ));
    }

    // THROW THE UNEXPECTED RESULT
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
