import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/course_search/course_search.dart';

class CourseSearchSection extends StatelessWidget {
  const CourseSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseSearchCubit(httpClient: context.read())..getCourses(),
      child: const CourseSearchView(),
    );
  }
}

class CourseSearchView extends StatelessWidget {
  const CourseSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CourseSearchBar(),
        CourseList(),
      ],
    );
  }
}
