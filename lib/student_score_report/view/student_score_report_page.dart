import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/student_score_report/cubit/student_score_report_cubit.dart';

class StudentScoreReportPage extends StatelessWidget {
  const StudentScoreReportPage({required this.student, super.key});
  final User student;

  static Route<void> route({required User student}) =>
      MaterialPageRoute(builder: (_) => StudentScoreReportPage(student: student));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentScoreReportCubit(
        httpClient: context.read(),
        student: student,
      )..getScoreReport(),
      child: const StudentScoreReportView(),
    );
  }
}

class StudentScoreReportView extends StatelessWidget {
  const StudentScoreReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreRecords = context.select((StudentScoreReportCubit cubit) => cubit.state.scoreRecords);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageTitle_StudentScoreReport),
      ),
      body: scoreRecords.isNotEmpty
          ? Table(
              children: [
                TableRow(
                  children: [
                    TitleCell(l10n.scoreRecordLabel_Course),
                    TitleCell(l10n.scoreRecordLabel_Type),
                    TitleCell(l10n.scoreRecordLabel_Grade),
                    TitleCell(l10n.scoreRecordLabel_Year),
                    TitleCell(l10n.scoreRecordLabel_Teacher),
                    TitleCell(l10n.scoreRecordLabel_Score),
                  ],
                ),
                for (final record in scoreRecords)
                  TableRow(
                    children: [
                      ContentCell(record.course.name),
                      ContentCell(EnumString.scoreRecordType(context, record.type)),
                      ContentCell(EnumString.grade(context, record.course.grade)),
                      ContentCell(record.course.year.toString()),
                      ContentCell(record.course.teacher.name),
                      ScoreCell(score: record.score),
                    ],
                  )
              ],
            )
          : Center(child: Text(l10n.scoreRecordLabel_NoScoresYet)),
    );
  }
}
