import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_assignment/create_assignment.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class CreateAssignmentForm extends StatefulWidget {
  const CreateAssignmentForm({super.key});

  @override
  State<CreateAssignmentForm> createState() => _CreateAssignmentFormState();
}

class _CreateAssignmentFormState extends State<CreateAssignmentForm> {
  final name = Field('');
  final type = Field<AssignmentType>();
  final dueDate = Field<DateTime>();

  @override
  Widget build(BuildContext context) {
    final loading = context.select((CreateAssignmentCubit cubit) => cubit.state.status.isLoading);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        // WHEN THE ASSIGNMENT HAS BEEN CREATED SUCCESSFULLY
        BlocListener<CreateAssignmentCubit, CreateAssignmentState>(
          listenWhen: (previous, current) => current.event == Events.createdAssignment,
          listener: (context, state) {
            context.nav.pop(state.newAssignment);
          },
        ),

        // WHEN THE SERVER THROWS A VALIDATION ERROR
        BlocListener<CreateAssignmentCubit, CreateAssignmentState>(
          listenWhen: (previous, current) => current.error == Errors.validationError,
          listener: (context, state) {
            name.error = toErrorString(context, state.validationError['name']);
            type.error = toErrorString(context, state.validationError['type']);
            dueDate.error = toErrorString(context, state.validationError['dueDate']);

            setState(() {});
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(Spacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ASSIGNMENT NAME FIELD
            TextField(
              onChanged: (value) => setState(() => name.update(value)),
              decoration: InputDecoration(
                labelText: l10n.formLabel_AssignmentName,
                errorText: name.error,
              ),
            ),
            const SizedBox(height: Spacing.m),

            // ASSIGNMENT TYPE FIELD
            DropdownButton(
              hint: Text(l10n.formLabel_SelectAssignmentType),
              focusColor: Colors.transparent,
              value: type.value,
              onChanged: (value) => setState(() => type.update(value)),
              items: [
                DropdownMenuItem(value: AssignmentType.homework, child: Text(l10n.assignmentType_Homework)),
                DropdownMenuItem(value: AssignmentType.quiz, child: Text(l10n.assignmentType_Quiz)),
                DropdownMenuItem(value: AssignmentType.midtermExam, child: Text(l10n.assignmentType_Midterm)),
                DropdownMenuItem(value: AssignmentType.finalExam, child: Text(l10n.assignmentType_FinalExam)),
                DropdownMenuItem(value: AssignmentType.participation, child: Text(l10n.assignmentType_Participation)),
              ],
            ),
            const SizedBox(height: Spacing.m),
            if (type.error != null)
              Text(
                type.error!,
                style: textTheme.labelMedium?.copyWith(color: colorScheme.error),
              ),
            const SizedBox(height: Spacing.m),

            // DUE DATE FIELD
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Spacing.m,
              runSpacing: Spacing.m,
              children: [
                Text(
                  dueDate.value == null
                      ? l10n.formLabel_SelectAssignmentDueDate
                      : l10n.scoreboardLabel_DueBy(dueDate.value!),
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        child: CalendarDatePicker(
                          initialDate: dueDate.value,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(
                              days: 366)), // adding a full year instead of half a year: reserving for future changes.
                          onDateChanged: (value) {
                            // UPDATE VALUE AND EXIT DIALOG
                            setState(() => dueDate.update(value));
                            context.nav.pop();
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.formLabel_SelectAssignmentDueDate),
                ),
              ],
            ),
            const SizedBox(height: Spacing.m),
            if (dueDate.error != null)
              Text(
                dueDate.error!,
                style: textTheme.labelMedium?.copyWith(color: colorScheme.error),
              ),
            const SizedBox(height: Spacing.m),

            // SUBMIT BUTTON
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: Text(l10n.buttonLabel_Submit))
          ],
        ),
      ),
    );
  }

  // WHEN THE USER PRESSES THE SUBMIT BUTTON
  void _submit() {
    // final loading = context.read<CreateAssignmentCubit>().state.status.isLoading;
    // if (loading) return;

    final l10n = context.l10n;

    // VALIDATE NAME
    if (name.value!.isEmpty) {
      name.error = l10n.validationError_Required;
    } else if (name.value!.length < 2) {
      name.error = l10n.validationError_TooShort(2);
    }

    // VALIDATE ASSIGNMENT TYPE
    if (type.value == null) {
      type.error = l10n.validationError_Required;
    }

    // VALIDATE DUE DATE
    if (dueDate.value == null) {
      dueDate.error = l10n.validationError_Required;
    }

    // WHEN THE USER HAS FINISHED EDITING PERSONAL INFO
    if (noErrorsIn([name, type, dueDate])) {
      context.read<CreateAssignmentCubit>().createAssignment(
            name: name.newValue!,
            type: type.newValue!,
            dueDate: dueDate.newValue!,
          );
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
