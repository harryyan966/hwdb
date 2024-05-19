import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/select_course_students/cubit/select_course_students_cubit.dart';
import 'package:hw_dashboard/user_search/user_search.dart';

class MultiSelectableStudentList extends StatelessWidget {
  const MultiSelectableStudentList({super.key});

  @override
  Widget build(BuildContext context) {
    final students = context.select((UserSearchCubit cubit) => cubit.state.users);
    final hasMore = context.select((UserSearchCubit cubit) => cubit.state.hasMore);
    final selected = context.select((SelectCourseStudentsCubit cubit) => cubit.state.selected);

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => context.read<UserSearchCubit>().reLoad(),
        child: ListView.builder(
          itemCount: students.length + 1,
          itemBuilder: (context, index) {
            // IF THE ITEM IS THE LAST ITEM
            if (index == students.length) {
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
        
            final student = students[index];
        
            // BUILD A USER INFO REPRESENTATION
        
            return MultiSelectableStudentItem(user: student, selected: selected.contains(student));
          },
        ),
      ),
    );
  }
}

class MultiSelectableStudentItem extends StatelessWidget {
  const MultiSelectableStudentItem({
    super.key,
    required this.user,
    required this.selected,
  });

  final User user;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(user.name),
      subtitle: Text(EnumString.userRole(context, user.role)),
      // USER PROFILE IMAGE
      secondary: CircleAvatar(
        backgroundImage: user.profileImageUrl.isEmpty
            ? Assets.images.defaultProfileImage.provider()
            : NetworkImage(user.profileImageUrl),
      ),
      value: selected,
      onChanged: (_) => context.read<SelectCourseStudentsCubit>().toggle(user),
    );
    // return ListTile(
    //   selected: true,
    //   title: Text(user.name),
    //   subtitle: Text(toUserRoleString(context, user.role)),
    //   leading: CircleAvatar(
    //     backgroundImage: user.profileImageUrl.isEmpty
    //         ? Assets.images.defaultProfileImage.provider()
    //         : NetworkImage(user.profileImageUrl),
    //   ),
    //   trailing: Checkbox(value: value, onChanged: onChanged),
    // );
  }
}
