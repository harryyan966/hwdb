import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_users/create_users.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/user_search/user_search.dart';

class CreateUserButton extends StatelessWidget {
  const CreateUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      onPressed: () {
        context.nav.push(CreateUsersPage.route()).then((users) {
          if (users != null && users.isNotEmpty) {
            return context.read<UserSearchCubit>().reLoad();
          }
        });
      },
      child: Text(l10n.linkLabel_CreateUser),
    );
  }
}
