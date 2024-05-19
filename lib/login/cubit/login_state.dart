part of 'login_cubit.dart';

@immutable
class LoginState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, ValidationErrors> validationError;
  final User user;

  const LoginState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.validationError = const {},
    this.user = const User.empty(),
  });

  LoginState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, ValidationErrors>? validationError,
    User? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      // TODO: do we need to make events none after every `copyWith`
      event: event ?? Events.none,
      error: error ?? Errors.none,

      // TODO: do we need to make VALIDATIONERRORS none after every `copyWith`?
      validationError: validationError ?? this.validationError,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status, event, error, validationError, user];
}
