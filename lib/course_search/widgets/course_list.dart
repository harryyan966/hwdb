import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/app/app.dart';
import 'package:hw_dashboard/course_search/course_search.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';
import 'package:hw_dashboard/student_score/student_score.dart';

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.select((CourseSearchCubit cubit) => cubit.state.courses);
    final hasMore = context.select((CourseSearchCubit cubit) => cubit.state.hasMore);
    final l10n = context.l10n;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => context.read<CourseSearchCubit>().reLoad(),
        child: courses.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.coursesLabel_NoCoursesYet, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: Spacing.l),
                  ElevatedButton(
                    onPressed: () => context.read<CourseSearchCubit>().reLoad(),
                    child: Text(l10n.buttonLabel_Refresh),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: courses.length + 1,
                itemBuilder: (context, index) {
                  // IF THE ITEM IS THE LAST ITEM
                  if (index == courses.length) {
                    if (hasMore) {
                      // IF THERE ARE MORE COURSES, BUILD THE LAST ITEM AS A LOADER
                      return Loader(onPresented: () {
                        context.read<CourseSearchCubit>().getCourses();
                      });
                    }

                    // IF THERE ARE NO MORE COURSES, REMOVE THE LAST ITEM
                    else {
                      return const SizedBox();
                    }
                  }

                  final course = courses[index];

                  // BUILD A COURSE INFO REPRESENTATION
                  return CourseInfoTile(course: course);
                },
              ),
      ),
    );
  }
}

class CourseInfoTile extends StatelessWidget {
  const CourseInfoTile({
    super.key,
    required this.course,
  });

  final CourseInfo course;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(course.name),
      subtitle: Text('${course.year} ${EnumString.grade(context, course.grade)}'),
      // TEACHER PROFILE
      trailing: TeacherProfile(teacher: course.teacher),
      onTap: () {
        final currentUser = context.read<AppCubit>().state.user;

        // GO TO EDITABLE SCOREBOARD PAGE
        if (currentUser.role.isTeacher && currentUser.id == course.teacher.id) {
          context.nav.push(EditableScoreBoardPage.route(course));
        }

        // GO TO READ-ONLY SCOREBOARD PAGE
        else if (currentUser.role.isAdmin || currentUser.role.isTeacher) {
          context.nav.push(ReadOnlyScoreBoardPage.route(course));
        }

        // GO TO PERSONAL SCOREBOARD PAGE
        else if (currentUser.role.isStudent) {
          context.nav.push(StudentScorePage.route(course, currentUser));
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
