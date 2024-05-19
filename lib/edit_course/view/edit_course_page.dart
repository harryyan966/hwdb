import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_course/edit_course.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class EditCoursePage extends StatelessWidget {
  const EditCoursePage({required this.courseInfo, super.key});
  final CourseInfo courseInfo;

  static Route<CourseInfo> route({required CourseInfo courseInfo}) =>
      MaterialPageRoute(builder: (_) => EditCoursePage(courseInfo: courseInfo));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCourseCubit(
        httpClient: context.read(),
        courseInfo: courseInfo,
      )..getStudents(),
      child: const EditCourseView(),
    );
  }
}

class EditCourseView extends StatefulWidget {
  const EditCourseView({super.key});

  @override
  State<EditCourseView> createState() => _EditCourseViewState();
}

class _EditCourseViewState extends State<EditCourseView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageTitle_EditCourse),
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.l),
              child: EditCourseForm(),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                EditTeacherSection(),
                SizedBox(height: Spacing.l),
                Expanded(child: EditStudentsSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
