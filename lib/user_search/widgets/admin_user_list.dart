import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_user/edit_user.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/student_score_report/view/student_score_report_page.dart';
import 'package:hw_dashboard/user_search/user_search.dart';

class AdminUserList extends StatelessWidget {
  const AdminUserList({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.select((UserSearchCubit cubit) => cubit.state.users);
    final hasMore = context.select((UserSearchCubit cubit) => cubit.state.hasMore);
    final l10n = context.l10n;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async =>  context.read<UserSearchCubit>().reLoad(),
        child: ListView.builder(
          itemCount: users.length + 1,
          itemBuilder: (context, index) {
            // IF THE ITEM IS THE LAST ITEM
            if (index == users.length) {
              return hasMore
                  ?
                  // IF THERE ARE MORE USERS, BUILD THE LAST ITEM AS A LOADER
                  Loader(onPresented: () {
                      context.read<UserSearchCubit>().getUsers();
                    })
                  :
        
                  // IF THERE ARE NO MORE USERS, REMOVE THE LAST ITEM
                  const SizedBox();
            }
        
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CHECK USER SCORES BUTTON
                  if (user.role.isStudent) ...[
                    ElevatedButton(
                      onPressed: () => context.nav.push(StudentScoreReportPage.route(student: user)),
                      child: Text(l10n.linkLabel_ViewScoreReport),
                    ),
                    const SizedBox(width: Spacing.m),
                  ],
        
                  if (user.role.isNotAdmin) ...[
                    // EDIT USER BUTTON
                    IconButton(
                      tooltip: l10n.linkLabel_Edit,
                      onPressed: () => context.nav.push(EditUserNamePage.route(user: user)).then((user) {
                        if (user != null) {
                          context.read<UserSearchCubit>().reLoad();
                        }
                      }),
                      icon: const Icon(Icons.edit_document),
                    ),
        
                    // DELETE USER BUTTON
                    const SizedBox(width: Spacing.m),
                    IconButton(
                      tooltip: l10n.buttonLabel_Remove,
                      onPressed: () => context.read<UserSearchCubit>().deleteUser(user.id),
                      icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
