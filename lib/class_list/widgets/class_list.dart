import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/class_list/class_list.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/student_score/student_score.dart';

import '../../class_score_board/view/class_score_board_page.dart';

class ClassList extends StatelessWidget {
  const ClassList({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = context.select((ClassListCubit cubit) => cubit.state.classes);
    final hasMore = context.select((ClassListCubit cubit) => cubit.state.hasMore);
    final l10n = context.l10n;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => context.read<ClassListCubit>().refreshClasses(),
        child: classes.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.classesLabel_NoClassesYet, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: Spacing.l),
                  ElevatedButton(
                    onPressed: () => context.read<ClassListCubit>().refreshClasses(),
                    child: Text(l10n.buttonLabel_Refresh),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: classes.length + 1,
                itemBuilder: (context, index) {
                  // IF THE ITEM IS THE LAST ITEM
                  if (index == classes.length) {
                    if (hasMore) {
                      // IF THERE ARE MORE CLASSES, BUILD THE LAST ITEM AS A LOADER
                      return Loader(onPresented: () {
                        context.read<ClassListCubit>().loadMoreClasses();
                      });
                    }

                    // IF THERE ARE NO MORE CLASSES, REMOVE THE LAST ITEM
                    else {
                      return const SizedBox();
                    }
                  }

                  final classInfo = classes[index];

                  // BUILD A CLASSES INFO REPRESENTATION
                  return ClassInfoTile(classInfo: classInfo);
                },
              ),
      ),
    );
  }
}

class ClassInfoTile extends StatelessWidget {
  const ClassInfoTile({
    super.key,
    required this.classInfo,
  });

  final ClassInfo classInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(classInfo.name),
      // TEACHER PROFILE
      trailing: TeacherProfile(teacher: classInfo.teacher),
      onTap: () {
        final currentUser = context.read<AppCubit>().state.user;

        // GO TO READ-ONLY SCOREBOARD PAGE
        if (currentUser.role.isAdmin || currentUser.role.isTeacher) {
          context.nav.push(ClassScoreBoardPage.route(classInfo));
        }

        // GO TO PERSONAL SCOREBOARD PAGE
        else if (currentUser.role.isStudent) {
          context.nav.push(StudentScorePage.route(classInfo, currentUser));
        }
      },
    );
  }
}

class TeacherProfile extends StatelessWidget {
  const TeacherProfile({
    super.key,
    required this.teacher,
  });

  final User teacher;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: teacher.profileImageUrl.isEmpty
              ? Assets.images.defaultProfileImage.provider()
              : NetworkImage(teacher.profileImageUrl),
        ),
        const SizedBox(width: Spacing.m),
        Text(
          teacher.name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
