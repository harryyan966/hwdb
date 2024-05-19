import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/course_search/course_search.dart';
import 'package:hw_dashboard/create_course/create_course.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class CreateCourseButton extends StatelessWidget {
  const CreateCourseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FloatingActionButton.extended(
      onPressed: () {
        context.nav.push(CreateCoursePage.route()).then((courseInfo) {
          if (courseInfo != null) {
            return context.read<CourseSearchCubit>().reLoad();
          }
        });
      },
      label: Text(l10n.linkLabel_CreateCourse),
    );
  }
}
