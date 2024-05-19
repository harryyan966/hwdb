import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_users/create_users.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class CreatedUsersList extends StatelessWidget {
  const CreatedUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.select((CreateUsersCubit cubit) => cubit.state.createdUsers);

    return Padding(
      padding: const EdgeInsets.all(Spacing.l),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          // BUILD A USER INFO REPRESENTATION
          return ListTile(
            title: Text(user.name),
            subtitle: Text(EnumString.userRole(context, user.role)),
            // USER PROFILE IMAGE
            leading: CircleAvatar(
              backgroundImage: user.profileImageUrl.isEmpty
                  ? Assets.images.defaultProfileImage.provider()
                  // TODO: change all network image instances to `CachedNetworkImage`
                  : NetworkImage(user.profileImageUrl),
            ),
            // DELETE USER BUTTON
            trailing: IconButton(
              onPressed: () => context.read<CreateUsersCubit>().deleteUser(user.id),
              icon: const Icon(Icons.delete_forever),
            ),
          );
        },
      ),
    );
  }
}
