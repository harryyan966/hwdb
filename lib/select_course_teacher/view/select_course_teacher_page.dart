import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/select_course_teacher/select_course_teacher.dart';
import 'package:hw_dashboard/user_search/user_search.dart';
import 'package:tools/tools.dart';

class SelectTeacherPage extends StatelessWidget {
  const SelectTeacherPage({super.key});

  static Route<User> route() => MaterialPageRoute(builder: (_) => const SelectTeacherPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchCubit(
        httpClient: context.read(),
      )..searchUsers(role: UserRole.teacher),
      child: const SelectTeacherView(),
    );
  }
}

class SelectTeacherView extends StatelessWidget {
  const SelectTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageTitle_SelectTeacher),
      ),
      body: const Column(
        children: [
          TeacherSearchBar(),
          SelectableTeacherList(),
        ],
      ),
    );
  }
}
