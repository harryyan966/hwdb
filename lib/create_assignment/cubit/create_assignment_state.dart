part of 'create_assignment_cubit.dart';

@immutable
class CreateAssignmentState extends Equatable {
  final PageStatus status;
  final Events event;
  final Errors error;
  final Map<String, ValidationErrors> validationError;
  final Assignment newAssignment;

  const CreateAssignmentState({
    this.status = PageStatus.good,
    this.event = Events.none,
    this.error = Errors.none,
    this.validationError = const {},
    this.newAssignment = const Assignment.empty(),
  });

  CreateAssignmentState copyWith({
    PageStatus? status,
    Events? event,
    Errors? error,
    Map<String, ValidationErrors>? validationError,
    Assignment? newAssignment,
  }) {
    return CreateAssignmentState(
      status: status ?? this.status,
      // TODO: do we need to make events none after every `copyWith`
      event: event ?? Events.none,
      error: error ?? Errors.none,
      validationError: validationError ?? this.validationError,
      newAssignment: newAssignment ?? this.newAssignment,
    );
  }

  @override
  List<Object> get props => [status, event, error, validationError, newAssignment];
}
