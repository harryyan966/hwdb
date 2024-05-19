import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/edit_course/edit_course.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/select_course_teacher/select_course_teacher.dart';

class EditTeacherSection extends StatelessWidget {
  const EditTeacherSection({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher = context.select((EditCourseCubit cubit) => cubit.state.teacher);
    final l10n = context.l10n;

    return Column(
      children: [
        ListTile(
          title: Text(l10n.formLabel_Teacher, style: Theme.of(context).textTheme.titleMedium),
          tileColor: Theme.of(context).colorScheme.surfaceContainer,
          trailing: ElevatedButton(
            onPressed: () {
              context.nav.push(SelectTeacherPage.route()).then((teacher) {
                if (teacher != null) {
                  context.read<EditCourseCubit>().updateTeacher(teacher);
                }
              });
            },
            child: Text(l10n.linkLabel_Edit),
          ),
        ),
        const SizedBox(height: Spacing.m),
        ListTile(
          title: Text(teacher.name),
          // subtitle: Text(toUserRoleString(context, teacher.role)),
          // USER PROFILE IMAGE
          leading: CircleAvatar(
            backgroundImage: teacher.profileImageUrl.isEmpty
                ? Assets.images.defaultProfileImage.provider()
                : NetworkImage(teacher.profileImageUrl),
          ),
        ),
      ],
    );
  }
}
