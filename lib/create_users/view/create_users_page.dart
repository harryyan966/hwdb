import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_users/create_users.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

class CreateUsersPage extends StatelessWidget {
  const CreateUsersPage({super.key});

  static Route<List<User>> route() => MaterialPageRoute(builder: (_) => const CreateUsersPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateUsersCubit(httpClient: context.read()),
      child: const CreateUsersView(),
    );
  }
}

class CreateUsersView extends StatefulWidget {
  const CreateUsersView({super.key});

  @override
  State<CreateUsersView> createState() => _CreateUsersViewState();
}

class _CreateUsersViewState extends State<CreateUsersView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loading = context.select((CreateUsersCubit cubit) => cubit.state.status.isLoading);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageTitle_CreateUser),
        actions: [
          loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    if (!loading) {
                      final users = context.read<CreateUsersCubit>().state.createdUsers;
                      context.nav.pop(users);
                    }
                  },
                  child: Text(l10n.buttonLabel_Ok),
                )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(Spacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CreateUserForm(),
            CreatedUsersLabel(),
            Expanded(child: CreatedUsersList()),
          ],
        ),
      ),
    );
  }
}
