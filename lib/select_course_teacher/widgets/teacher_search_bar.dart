import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/user_search/user_search.dart';

class TeacherSearchBar extends StatelessWidget {
  const TeacherSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(Spacing.m),
      child: TextField(
        decoration: InputDecoration(
          labelText: l10n.searchBarLabel_SearchUsers,
        ),
        onSubmitted: (keyword) => _submit(context, keyword),
      ),
    );
  }

  // WHEN THE USER SUBMITS A KEYWORD
  void _submit(BuildContext context,String keyword) {
    context.read<UserSearchCubit>().searchUsers(keyword: keyword);
    // TODO: test if we need , role: UserRole.teacher
  }
}
