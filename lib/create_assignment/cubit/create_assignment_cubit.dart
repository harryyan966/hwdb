import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'create_assignment_state.dart';

class CreateAssignmentCubit extends Cubit<CreateAssignmentState> {
  CreateAssignmentCubit({
    required HwdbHttpClient httpClient,
    required this.courseId,
  })  : _httpClient = httpClient,
        super(const CreateAssignmentState());

  final HwdbHttpClient _httpClient;
  final String courseId;

  Future<void> createAssignment({
    required String name,
    required AssignmentType type,
    required DateTime dueDate,
  }) async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: PageStatus.loading));

    // CREATE ASSIGNMENT IN THE SERVER
    final res = await _httpClient.post('courses/$courseId/assignments', args: {
      'name': name,
      'type': type.name,
      'dueDate': dueDate.toIso8601String(),
    });

    // IF THE ASSIGNMENT IS CREATED ON THE SERVER
    if (Events.createdAssignment.matches(res['event'])) {
      emit(state.copyWith(
        status: PageStatus.good,
        event: Events.createdAssignment,
        newAssignment: Assignment.fromJson(res['data']),
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

    // THROW ANY UNEXPECTED RESULTS
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }
}
