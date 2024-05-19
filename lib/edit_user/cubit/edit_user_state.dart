part of 'edit_user_cubit.dart';

@immutable
class EditUserState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, ValidationErrors> validationError;
  final User newUser;
  
  const EditUserState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.validationError = const {},
    this.newUser = const User.empty(),
  });

  EditUserState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, ValidationErrors>? validationError,
    User? newUser,
  }) {
    return EditUserState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      validationError: validationError ?? const {},
      newUser: newUser ?? this.newUser,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      event,
      error,
      validationError,
      newUser,
    ];
  }
}
