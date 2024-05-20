import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/home/home.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/login/login.dart';
import 'package:tools/tools.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final username = Field('');
  final password = Field('');

  // TODO: how to sync up the field editing and value changing? replace fields with controllers?

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loading = context.select((LoginCubit cubit) => cubit.state.status.isLoading);

    return MultiBlocListener(
      listeners: [
        // WHEN THE USER HAS AUTO-LOGGED IN
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => current.event == Events.gotCurrentUser,
          listener: (context, state) {
            context.nav.jump(HomePage.route());
            context.read<AppCubit>().updateUser(state.user);
          },
        ),

        // WHEN THE USER HAS LOGGED IN SUCCESSFULLY
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => current.event == Events.loggedIn,
          listener: (context, state) {
            context.nav.jump(HomePage.route());
            context.read<AppCubit>().updateUser(state.user);
          },
        ),

        // WHEN THE SERVER THROWS A VALIDATION ERROR
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => current.error == Errors.validationError,
          listener: (context, state) {
            username.error = toErrorString(context, state.validationError['username']);
            password.error = toErrorString(context, state.validationError['password']);

            setState(() {});
          },
        ),

        // WHEN THE CREDENTIALS ARE INVALID
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) => current.error == Errors.invalidCredentials,
          listener: (context, state) {
            showSimpleDialog(context, title: l10n.prompt_FailedToLogIn);
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LOGIN TITLE
          Text(l10n.pageTitle_LogIn, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Spacing.m),

          // USERNAME FIELD
          TextField(
            onChanged: (value) => setState(() => username.update(value)),
            decoration: InputDecoration(
              labelText: l10n.formLabel_UserName,
              errorText: username.error,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: Spacing.m),

          // PASSWORD FIELD
          TextField(
            onChanged: (value) => setState(() => password.update(value)),
            decoration: InputDecoration(
              labelText: l10n.formLabel_Password,
              errorText: password.error,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: Spacing.xxl),

          // SUBMIT BUTTON
          loading
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _submit, child: Text(l10n.buttonLabel_Submit)),
        ],
      ),
    );
  }

  // WHEN THE USER PRESSES THE SUBMIT BUTTON
  void _submit() {
    final l10n = context.l10n;

    // VALIDATE NAME
    if (username.value!.isEmpty) {
      username.error = l10n.validationError_Required;
    }

    // VALIDATE PASSWORD
    if (password.value!.isEmpty) {
      password.error = l10n.validationError_Required;
    }

    // WHEN THE USER HAS FINISHED EDITING PERSONAL INFO
    if (noErrorsIn([username, password])) {
      context.read<LoginCubit>().logIn(
            username: username.newValue!,
            password: password.newValue!,
          );
    }

    // WHEN THERE ARE ERRORS IN THE FIELDS
    else {
      setState(() {});
    }
  }
}
