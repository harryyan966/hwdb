part of 'create_users_cubit.dart';

@immutable
class CreateUsersState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, ValidationErrors> validationError;
  final List<User> createdUsers;

  const CreateUsersState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.validationError = const {},
    this.createdUsers = const [],
  });

  CreateUsersState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, ValidationErrors>? validationError,
    List<User>? createdUsers,
  }) {
    return CreateUsersState(
      status: status ?? this.status,
      event: event ?? Events.none,
      error: error ?? Errors.none,
      validationError: validationError ?? const {},
      createdUsers: createdUsers ?? this.createdUsers,
    );
  }

  @override
  List<Object> get props => [status, event, error, validationError, createdUsers];
}
