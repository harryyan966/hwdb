import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_course/cubit/edit_course_cubit.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/select_course_students/select_course_students.dart';

class EditStudentsSection extends StatelessWidget {
  const EditStudentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final students = context.select((EditCourseCubit cubit) => cubit.state.sortedStudents);
    final l10n = context.l10n;

    return Column(
      children: [
        ListTile(
          title: Text(l10n.formLabel_Students, style: Theme.of(context).textTheme.titleMedium),
          tileColor: Theme.of(context).colorScheme.surfaceContainer,
          // EDIT TEACHER
          trailing: ElevatedButton(
            onPressed: () {
              final courseId = context.read<EditCourseCubit>().courseInfo.id;
              context.nav.push(SelectCourseStudentsPage.route(courseId: courseId, students: students)).then((students) {
                if (students != null) {
                  context.read<EditCourseCubit>().updateStudents(students);
                }
              });
            },
            child: Text(l10n.linkLabel_Edit),
          ),
        ),
        const SizedBox(height: Spacing.m),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              // BUILD A USER INFO REPRESENTATION
              return ListTile(
                title: Text(student.name),
                // USER PROFILE IMAGE
                leading: CircleAvatar(
                  backgroundImage: student.profileImageUrl.isEmpty
                      ? Assets.images.defaultProfileImage.provider()
                      : NetworkImage(student.profileImageUrl),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
