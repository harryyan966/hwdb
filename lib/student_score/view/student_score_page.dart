import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';

class StudentScorePage extends StatelessWidget {
  const StudentScorePage({
    required this.classInfo,
    required this.student,
    super.key,
  });

  final ClassInfo classInfo;
  final User student;

  static Route<void> route(ClassInfo classInfo, User student) => MaterialPageRoute(
      builder: (_) => StudentScorePage(
            classInfo: classInfo,
            student: student,
          ));

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("NOTHING HERE :("),
      ),
    );
  }
}
