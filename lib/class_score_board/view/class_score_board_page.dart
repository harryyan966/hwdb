import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';

class ClassScoreBoardPage extends StatelessWidget {
  const ClassScoreBoardPage({required this.classInfo, super.key});

  final ClassInfo classInfo;

  static Route<void> route(ClassInfo classInfo) =>
      MaterialPageRoute(builder: (_) => ClassScoreBoardPage(classInfo: classInfo));

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("NOTHING HERE :("),
      ),
    );
  }
}
