import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_user/edit_user.dart';

class EditUserPasswordPage extends StatelessWidget {
  const EditUserPasswordPage({required this.currentUser, super.key});
  final User currentUser;

  static Route<User> route({required User currentUser}) =>
      MaterialPageRoute(builder: (_) => EditUserPasswordPage(currentUser: currentUser));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditUserCubit(httpClient: context.read(), user: currentUser),
      child: const EditUserPasswordView(),
    );
  }
}

class EditUserPasswordView extends StatefulWidget {
  const EditUserPasswordView({super.key});

  @override
  State<EditUserPasswordView> createState() => _EditUserPasswordViewState();
}

class _EditUserPasswordViewState extends State<EditUserPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(Spacing.l),
            child: EditUserPasswordForm(),
          ),
        ),
      ),
    );
  }
}
