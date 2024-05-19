import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/account/account.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/login/login.dart';
import 'package:tools/tools.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = context.select((AccountCubit cubit) => cubit.state.status.isLoading);
    final l10n = context.l10n;

    return BlocListener<AccountCubit, AccountState>(
      listenWhen: (previous, current) => current.event == Events.loggedOut,
      listener: (context, state) {
        // WHEN THE SERVER HAS ACKNOWLEDGED THE USER'S LOG OUT
        context.nav.jump(LoginPage.route()).then((_) {
          context.read<AppCubit>().updateUser(const User.empty());
        });
      },
      child: loading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              // WHEN THE USER PUSHES THE LOG OUT BUTTON
              onPressed: () => context.read<AccountCubit>().logOut(),
              child: Text(l10n.buttonLabel_LogOut),
            ),
    );
  }
}
