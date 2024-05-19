import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/edit_user/edit_user.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class EditUserNameButton extends StatelessWidget {
  const EditUserNameButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      onPressed: () {
        final user = context.read<AppCubit>().state.user;
        context.nav.push(EditUserNamePage.route(user: user)).then((user) {
          if (user != null) {
            context.read<AppCubit>().updateUser(user);
          }
        });
      },
      child: Text(l10n.linkLabel_EditUserName),
    );
  }
}
