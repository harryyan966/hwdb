import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/create_assignment/create_assignment.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

class CreateAssignmentPage extends StatelessWidget {
  const CreateAssignmentPage({required this.courseInfo, super.key});

  final CourseInfo courseInfo;

  static Route<Assignment> route({required CourseInfo courseInfo}) =>
      MaterialPageRoute(builder: (_) => CreateAssignmentPage(courseInfo: courseInfo));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateAssignmentCubit(
            httpClient: context.read(),
            courseId: courseInfo.id,
          ),
        ),
      ],
      child: const CreateAssignmentView(),
    );
  }
}

class CreateAssignmentView extends StatefulWidget {
  const CreateAssignmentView({super.key});

  @override
  State<CreateAssignmentView> createState() => _CreateAssignmentViewState();
}

class _CreateAssignmentViewState extends State<CreateAssignmentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.pageTitle_CreateAssignment),
      ),
      body: const Center(
        child: SizedBox(
          width: 640,
          child: Padding(
            padding: EdgeInsets.all(Spacing.l),
            child: CreateAssignmentForm(),
          ),
        ),
      ),
    );
  }
}
