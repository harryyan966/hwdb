import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/user_search/user_search.dart';

class SelectableTeacherList extends StatelessWidget {
  const SelectableTeacherList({super.key});

  @override
  Widget build(BuildContext context) {
    final teachers = context.select((UserSearchCubit cubit) => cubit.state.users);
    final hasMore = context.select((UserSearchCubit cubit) => cubit.state.hasMore);

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => context.read<UserSearchCubit>().reLoad(),
        child: ListView.builder(
          itemCount: teachers.length + 1,
          itemBuilder: (context, index) {
            // IF THE ITEM IS THE LAST ITEM
            if (index == teachers.length) {
              if (hasMore) {
                // IF THERE ARE MORE USERS, BUILD THE LAST ITEM AS A LOADER
                return Loader(onPresented: () {
                  context.read<UserSearchCubit>().getUsers();
                });
              }
        
              // IF THERE ARE NO MORE USERS, REMOVE THE LAST ITEM
              else {
                return const SizedBox();
              }
            }
        
            final teacher = teachers[index];
        
            // BUILD A USER INFO REPRESENTATION
        
            return SelectableTeacherItem(teacher: teacher);
          },
        ),
      ),
    );
  }
}

class SelectableTeacherItem extends StatelessWidget {
  const SelectableTeacherItem({
    super.key,
    required this.teacher,
  });

  final User teacher;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(teacher.name),
      subtitle: Text(EnumString.userRole(context, teacher.role)),
      // USER PROFILE IMAGE
      leading: CircleAvatar(
        backgroundImage: teacher.profileImageUrl.isEmpty
            ? Assets.images.defaultProfileImage.provider()
            : NetworkImage(teacher.profileImageUrl),
      ),
      onTap: () => context.nav.pop(teacher),
    );
  }
}
