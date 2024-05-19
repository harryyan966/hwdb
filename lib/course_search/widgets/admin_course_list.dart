import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/course_search/course_search.dart';
import 'package:hw_dashboard/edit_course/edit_course.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class AdminCourseList extends StatelessWidget {
  const AdminCourseList({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.select((CourseSearchCubit cubit) => cubit.state.courses);
    final hasMore = context.select((CourseSearchCubit cubit) => cubit.state.hasMore);
    final l10n = context.l10n;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => context.read<CourseSearchCubit>().reLoad(),
        child: ListView.builder(
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
            final teacher = course.teacher;
        
            // BUILD A COURSE INFO REPRESENTATION
            return ListTile(
              title: Text(course.name),
              subtitle: Text('${course.year} ${EnumString.grade(context, course.grade)}'),
              // TEACHER PROFILE
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TEACHER PROFILE
                  CircleAvatar(
                    backgroundImage: teacher.profileImageUrl.isEmpty
                        ? Assets.images.defaultProfileImage.provider()
                        : NetworkImage(teacher.profileImageUrl),
                  ),
                  const SizedBox(width: Spacing.m),
                  Text(
                    teacher.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
        
                  // EDIT COURSE BUTTON
                  const SizedBox(width: Spacing.m),
                  IconButton(
                    tooltip: l10n.linkLabel_Edit,
                    onPressed: () => context.nav.push(EditCoursePage.route(courseInfo: course)).then((courseInfo) {
                      if (courseInfo != null) {
                        context.read<CourseSearchCubit>().reLoad();
                      }
                    }),
                    icon: const Icon(Icons.edit_document),
                  ),
        
                  // DELETE COURSE BUTTON
                  const SizedBox(width: Spacing.m),
                  IconButton(
                    tooltip: l10n.buttonLabel_Remove,
                    onPressed: () => context.read<CourseSearchCubit>().deleteCourse(course.id),
                    icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
