import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/course_search/course_search.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class ManageCoursesPage extends StatelessWidget {
  const ManageCoursesPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const ManageCoursesPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseSearchCubit(httpClient: context.read()),
      child: const AdminCourseSearchView(),
    );
  }
}

class AdminCourseSearchView extends StatelessWidget {
  const AdminCourseSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pageTitle_ManageCourses)),
      body: const Column(
        children: [
          CourseSearchBar(),
          AdminCourseList(),
        ],
      ),
      floatingActionButton: const CreateCourseButton(),
    );
  }
}
