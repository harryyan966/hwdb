import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_course/create_course.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class CreateCoursePage extends StatelessWidget {
  const CreateCoursePage({super.key});

  static Route<CourseInfo> route() => MaterialPageRoute(builder: (_) => const CreateCoursePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCourseCubit(
        httpClient: context.read(),
      ),
      child: const CreateCourseView(),
    );
  }
}

class CreateCourseView extends StatefulWidget {
  const CreateCourseView({super.key});

  @override
  State<CreateCourseView> createState() => _CreateCourseViewState();
}

class _CreateCourseViewState extends State<CreateCourseView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pageTitle_CreateCourse)),
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(Spacing.l),
            child: CreateCourseForm(),
          ),
        ),
      ),
    );
  }
}
