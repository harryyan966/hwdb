import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class AccountProfile extends StatelessWidget {
  const AccountProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppCubit cubit) => cubit.state.user);
    final textTheme = Theme.of(context).textTheme;

    assert(user.isNotEmpty, 'user is empty');

    return Padding(
      padding: const EdgeInsets.all(Spacing.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // USER PROFILE IMAGE
          CircleAvatar(
            backgroundImage: user.profileImageUrl.isNotEmpty
                ? NetworkImage(user.profileImageUrl)
                : Assets.images.defaultProfileImage.provider(),
            maxRadius: 64,
          ),
          const SizedBox(width: Spacing.s),

          // USER NAME
          Text(user.name, style: textTheme.labelLarge),
          const SizedBox(width: Spacing.s),

          // USER ROLE TAG
          Text(
            EnumString.userRole(context, user.role),
            style: textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              // color: switch (user.role) {
              //   UserRole.admin => Colors.redAccent,
              //   UserRole.teacher => Colors.purpleAccent,
              //   UserRole.student => Colors.blueAccent,
              //   UserRole.none => throw Exception('VISITORS SHOULD NOT BE HERE'),
              // },
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
