import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/user_search/user_search.dart';
import 'package:tools/tools.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({super.key});

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedRole = context.select((UserSearchCubit cubit) => cubit.state.role);

    return Padding(
      padding: const EdgeInsets.all(Spacing.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // NAME SEARCH BAR
          TextField(
            decoration: InputDecoration(
              labelText: l10n.pageTitle_SearchUsers,
            ),
            onSubmitted: (value) => _submit(value),
          ),
          const SizedBox(height: Spacing.m),

          // FIELDS SEARCH CHIPS
          Wrap(
            spacing: Spacing.s,
            runSpacing: Spacing.s,
            children: [
              ChoiceChip(
                label: Text(l10n.generalLabel_All),
                selected: UserRole.none == selectedRole,
                onSelected: (_) {
                  context.read<UserSearchCubit>().searchUsers(role: UserRole.none);
                },
              ),
              for (final role in [UserRole.student, UserRole.teacher, UserRole.admin])
                ChoiceChip(
                  label: Text(EnumString.userRole(context, role)),
                  selected: role == selectedRole,
                  onSelected: (_) {
                    context.read<UserSearchCubit>().searchUsers(role: role);
                  },
                ),
            ],
          )
        ],
      ),
    );
  }

  // WHEN THE USER SUBMITS A KEYWORD
  void _submit(String keyword) {
    // TODO: test user role chip
    context.read<UserSearchCubit>().searchUsers(keyword: keyword);
  }
}
