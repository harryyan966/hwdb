part of 'account_cubit.dart';

@immutable
class AccountState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;

  const AccountState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
  });

  AccountState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
  }) {
    return AccountState(
      status: status ?? this.status,      
      event: event ?? Events.none,
      error: error ?? Errors.none,
    );
  }

  @override
  List<Object> get props => [status, event, error];
}
