import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/user_search/user_search.dart';
import 'package:hw_dashboard/user_search/widgets/create_user_button.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const ManageUsersPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchCubit(httpClient: context.read()),
      child: const UserSearchView(),
    );
  }
}

class UserSearchView extends StatelessWidget {
  const UserSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageTitle_ManageUsers),
        actions: const [CreateUserButton(), SizedBox(width: Spacing.m)],
      ),
      body: const Column(
        children: [
          UserSearchBar(),
          AdminUserList(),
        ],
      ),
    );
  }
}
