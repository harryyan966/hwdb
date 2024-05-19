import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/account/account.dart';
import 'package:hw_dashboard/app/cubit/app_cubit.dart';

class AccountActions extends StatelessWidget {
  const AccountActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isStudent = context.select((AppCubit cubit) => cubit.state.user.role.isStudent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.m),
      child: Wrap(
        spacing: Spacing.s,
        runSpacing: Spacing.s,
        children: [
          const LogOutButton(),
          if (!isStudent) const EditUserNameButton(),
          const EditUserPasswordButton(),
        ],
      ),
    );
  }
}
