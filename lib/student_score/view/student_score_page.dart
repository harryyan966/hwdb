import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/student_score/student_score.dart';

class StudentScorePage extends StatelessWidget {
  const StudentScorePage({required this.courseInfo, required this.student, super.key});

  final CourseInfo courseInfo;
  final User student;

  static Route<void> route(
    CourseInfo courseInfo,
    User student,
  ) =>
      MaterialPageRoute(
          builder: (_) => StudentScorePage(
                courseInfo: courseInfo,
                student: student,
              ));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentScoreCubit(
        httpClient: context.read(),
        courseInfo: courseInfo,
        student: student,
      )..getScores(),
      child: const StudentScoreView(),
    );
  }
}

class StudentScoreView extends StatelessWidget {
  const StudentScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final courseName = context.read<StudentScoreCubit>().courseInfo.name;

    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: const Padding(
        padding: EdgeInsets.all(Spacing.l),
        child: StudentScoreList(),
      ),
    );
  }
}
