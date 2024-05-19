import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_user/edit_user.dart';

class EditUserNamePage extends StatelessWidget {
  const EditUserNamePage({required this.user, super.key});
  final User user;

  static Route<User> route({required User user}) => MaterialPageRoute(builder: (_) => EditUserNamePage(user: user));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditUserCubit(httpClient: context.read(), user: user),
      child: const EditUserNameView(),
    );
  }
}

class EditUserNameView extends StatefulWidget {
  const EditUserNameView({super.key});

  @override
  State<EditUserNameView> createState() => _EditUserNameViewState();
}

class _EditUserNameViewState extends State<EditUserNameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(Spacing.l),
            child: EditUserNameForm(),
          ),
        ),
      ),
    );
  }
}
