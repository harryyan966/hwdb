import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_users/create_users.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final name = Field('');
  final password = Field('');
  final role = Field<UserRole>();

  @override
  Widget build(BuildContext context) {
    final loading = context.select((CreateUsersCubit cubit) => cubit.state.status.isLoading);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        // WHEN THE USER HAS BEEN CREATED SUCCESSFULLY
        BlocListener<CreateUsersCubit, CreateUsersState>(
          listenWhen: (previous, current) => current.event == Events.createdUser,
          // SHOW A SNACKBAR TO NOTIFY THE USER
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.prompt_CreatedUser)),
            );
          },
        ),

        // WHEN THE SERVER THROWS A VALIDATION ERROR
        BlocListener<CreateUsersCubit, CreateUsersState>(
          listenWhen: (previous, current) => current.error == Errors.validationError,
          listener: (context, state) {
            name.error = toErrorString(context, state.validationError['name']);
            password.error = toErrorString(context, state.validationError['password']);
            role.error = toErrorString(context, state.validationError['role']);
            
            setState(() {});
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(Spacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // NAME FIELD
            TextField(
              onChanged: (value) => setState(() => name.update(value)),
              decoration: InputDecoration(labelText: l10n.formLabel_UserName, errorText: name.error),
            ),
            const SizedBox(height: Spacing.m),

            // PASSWORD FIELD
            TextField(
              onChanged: (value) => setState(() => password.update(value)),
              decoration: InputDecoration(labelText: l10n.formLabel_Password, errorText: password.error),
            ),
            const SizedBox(height: Spacing.m),

            // USER ROLE FIELD
            DropdownButton(
              hint: Text(l10n.formLabel_SelectUserRole),
              focusColor: Colors.transparent,
              value: role.value,
              onChanged: (value) => setState(() => role.update(value)),
              items: [
                DropdownMenuItem(value: UserRole.student, child: Text(l10n.userRole_Student)),
                DropdownMenuItem(value: UserRole.teacher, child: Text(l10n.userRole_Teacher)),
                DropdownMenuItem(value: UserRole.admin, child: Text(l10n.userRole_Admin)),
              ],
            ),
            const SizedBox(height: Spacing.m),
            if (role.error != null)
              Text(
                role.error!,
                style: textTheme.labelMedium?.copyWith(color: colorScheme.error),
              ),
            const SizedBox(height: Spacing.m),

            // SUBMIT BUTTON
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _submit, child: Text(l10n.buttonLabel_Submit)),
          ],
        ),
      ),
    );
  }

  // WHEN THE USER PRESSES THE SUBMIT BUTTON
  void _submit() {
    final l10n = context.l10n;

    // VALIDATE NAME
    if (name.value!.isEmpty) {
      name.error = l10n.validationError_Required;
    } else if (name.value!.length < 2) {
      name.error = l10n.validationError_TooShort(2);
    }

    // VALIDATE PASSWORD
    if (password.value!.isEmpty) {
      password.error = l10n.validationError_Required;
    } else if (password.value!.length < 8) {
      password.error = l10n.validationError_TooShort(8);
    }

    // VALIDATE USER ROLE
    if (role.value == null) {
      role.error = l10n.validationError_Required;
    }

    // WHEN THE USER HAS FINISHED EDITING PERSONAL INFO
    if (noErrorsIn([name, password, role])) {
      context.read<CreateUsersCubit>().createUser(
            name: name.newValue!,
            password: password.newValue!,
            role: role.newValue!,
          );
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
