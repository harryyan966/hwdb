import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_user/cubit/edit_user_cubit.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class EditUserPasswordForm extends StatefulWidget {
  const EditUserPasswordForm({super.key});

  @override
  State<EditUserPasswordForm> createState() => _EditUserPasswordFormState();
}

class _EditUserPasswordFormState extends State<EditUserPasswordForm> {
  final oldPassword = Field('');
  final newPassword = Field('');
  final confirmNewPassword = Field('');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        // WHEN THE USER IS SUCCESSFULLY UPDATED ON THE SERVER
        BlocListener<EditUserCubit, EditUserState>(
          listenWhen: (previous, current) => current.event == Events.updatedUser,
          listener: (context, state) {
            context.nav.pop(state.newUser);
          },
        ),

        // WHEN THE SERVER THROWS A VALIDATION ERROR
        BlocListener<EditUserCubit, EditUserState>(
          listenWhen: (previous, current) => current.error == Errors.validationError,
          listener: (context, state) {
            oldPassword.error = toErrorString(context, state.validationError['oldPassword']);
            newPassword.error = toErrorString(context, state.validationError['newPassword']);
            
            setState(() {});
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // OLD PASSWORD FIELD
          TextField(
            onChanged: (value) => setState(() => oldPassword.update(value)),
            decoration: InputDecoration(hintText: l10n.formLabel_OldPassword, errorText: oldPassword.error),
          ),
          const SizedBox(height: Spacing.m),

          // NEW PASSWORD FIELD
          TextField(
            onChanged: (value) => setState(() => newPassword.update(value)),
            decoration: InputDecoration(hintText: l10n.formLabel_NewPassword, errorText: newPassword.error),
          ),
          const SizedBox(height: Spacing.m),

          // CONFIRM NEW PASSWORD FIELD
          TextField(
            onChanged: (value) => setState(() => confirmNewPassword.update(value)),
            decoration:
                InputDecoration(hintText: l10n.formLabel_ConfirmNewPassword, errorText: confirmNewPassword.error),
          ),
          const SizedBox(height: Spacing.m),

          Row(
            children: [
              // SUBMIT BUTTON
              ElevatedButton(onPressed: () => _submit(), child: Text(l10n.buttonLabel_Submit)),
              const SizedBox(width: Spacing.m),

              // CANCEL BUTTON
              ElevatedButton(onPressed: () => context.nav.pop(), child: Text(l10n.buttonLabel_Cancel)),
            ],
          ),
        ],
      ),
    );
  }

  // WHEN THE USER PUSHES THE SUBMIT BUTTON
  void _submit() {
    final l10n = context.l10n;

    // VALIDATE OLD PASSWORD
    if (oldPassword.value!.isEmpty) {
      oldPassword.error = l10n.validationError_Required;
    }

    // VALIDATE NEW PASSWORD
    if (newPassword.value!.isEmpty) {
      newPassword.error = l10n.validationError_Required;
    } else if (newPassword.value!.length < 8) {
      newPassword.error = l10n.validationError_TooShort(8);
    } else if (newPassword.value == oldPassword.value) {
      newPassword.error = l10n.validationError_SamePasswords;
    }

    // VALIDATE CONFIRM NEW PASSWORD
    if (newPassword.error == null) {
      if (confirmNewPassword.value! != newPassword.value) {
        confirmNewPassword.error = l10n.validationError_PasswordsDontMatch;
      }
    }

    // WHEN THE USER HAS FINISHED EDITING PERSONAL INFO
    if (noErrorsIn([oldPassword, newPassword, confirmNewPassword])) {
      context.read<EditUserCubit>().editUser(
            oldPassword: oldPassword.newValue,
            newPassword: newPassword.newValue,
          );
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
