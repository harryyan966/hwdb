import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_user/cubit/edit_user_cubit.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class EditUserNameForm extends StatefulWidget {
  const EditUserNameForm({super.key});

  @override
  State<EditUserNameForm> createState() => _EditUserNameFormState();
}

class _EditUserNameFormState extends State<EditUserNameForm> {
  final name = Field('');

  @override
  void initState() {
    super.initState();

    name.value = context.read<EditUserCubit>().user.name;
  }

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
            name.error = toErrorString(context, state.validationError['name']);
            
            setState(() {});
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // NAME FIELD
          TextField(
            onChanged: (value) => setState(() => name.update(value)),
            decoration: InputDecoration(hintText: l10n.formLabel_NewUserName, errorText: name.error),
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

    // VALIDATE NAME
    if (name.value!.isEmpty) {
      name.error = l10n.validationError_Required;
    } else if (name.value!.length < 2) {
      name.error = l10n.validationError_TooShort(2);
    } else if (name.value == context.read<EditUserCubit>().user.name) {
      name.error = l10n.validationError_SameUserNames;
    }

    // WHEN THE USER HAS FINISHED EDITING THE NAME
    if (noErrorsIn([name])) {
      context.read<EditUserCubit>().editUser(name: name.newValue!);
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
