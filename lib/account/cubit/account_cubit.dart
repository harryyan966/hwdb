import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({required HwdbHttpClient httpClient})
      : _httpClient = httpClient,
        super(const AccountState());
  final HwdbHttpClient _httpClient;

  /// Logs the user out.
  Future<void> logOut() async {
    // DO NOTHING IF THE PAGE IS LOADING
    if (state.status.isLoading) {
      return;
    }

    // START LOADING
    emit(state.copyWith(status: PageStatus.loading));

    // REQUEST THE SERVER TO LOG OUT
    final res = await _httpClient.post('auth/logout');

    // IF THE USER HAS LOGGED OUT SUCCESSFULLY
    if (Events.loggedOut.matches(res['event'])) {
      emit(state.copyWith(status: PageStatus.good, event: Events.loggedOut));
    }

    // THROW ANY UNEXPECTED RESPONOSE
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
