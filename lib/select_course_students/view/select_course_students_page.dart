import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/select_course_students/select_course_students.dart';
import 'package:hw_dashboard/user_search/user_search.dart';
import 'package:tools/tools.dart';

class SelectCourseStudentsPage extends StatelessWidget {
  const SelectCourseStudentsPage({required this.courseId, required this.students, super.key});
  final String courseId;
  final List<User> students;

  static Route<List<User>> route({required String courseId, required List<User> students}) =>
      MaterialPageRoute(builder: (_) => SelectCourseStudentsPage(courseId: courseId, students: students));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // FOR KEEPING A RECORD OF THE SELECTIONS AND SENDING UPDATE REQUEST
        BlocProvider(
          create: (_) => SelectCourseStudentsCubit(
            courseId: courseId,
            students: students,
          ),
        ),

        // FOR GETTING ALL AVAILABLE STUDENTS
        BlocProvider(
          create: (context) => UserSearchCubit(
            httpClient: context.read(),
          )..searchUsers(role: UserRole.student),
        ),
      ],
      child: const SelectStudentsView(),
    );
  }
}

class SelectStudentsView extends StatelessWidget {
  const SelectStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SelectCourseStudentsCubit, SelectCourseStudentsState>(
      // GO TO PREVIOUS PAGE WHEN THE SELECTION IS UPDATED ON THE SERVER
      listenWhen: (previous, current) => current.done,
      listener: (context, state) {
        context.nav.pop(state.selected.toList());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.pageTitle_SelectStudents),
          automaticallyImplyLeading: false, // DON'T SHOW THE BACK BUTTON
          actions: [
            // SEND UPDATE REQUEST
            ElevatedButton(
              onPressed: () => context.read<SelectCourseStudentsCubit>().updateCourseStudentList(),
              child: Text(l10n.buttonLabel_Ok),
            ),
            const SizedBox(width: Spacing.m),
          ],
        ),
        body: const Column(
          children: [
            StudentSearchBar(),
            MultiSelectableStudentList(),
          ],
        ),
      ),
    );
  }
}
