import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:hw_dashboard/score_board/score_board.dart';
import 'package:tools/tools.dart';

class ReadOnlyScoreBoardPage extends StatelessWidget {
  const ReadOnlyScoreBoardPage({required this.courseInfo, super.key});

  final CourseInfo courseInfo;

  static Route<void> route(CourseInfo courseInfo) =>
      MaterialPageRoute(builder: (_) => ReadOnlyScoreBoardPage(courseInfo: courseInfo));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScoreBoardCubit(
        httpClient: context.read(),
        courseInfo: courseInfo,
      )..getScoreBoard(),
      child: const ReadOnlyScoreboardView(),
    );
  }
}

class ReadOnlyScoreboardView extends StatelessWidget {
  const ReadOnlyScoreboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final courseName = context.read<ScoreBoardCubit>().courseInfo.name;
    final loading = context.select((ScoreBoardCubit cubit) => cubit.state.status.isLoading);
    final hasStudents = context.select((ScoreBoardCubit cubit) => cubit.state.students.isNotEmpty);
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScoreBoardCubit, ScoreBoardState>(
          listenWhen: (previous, current) => current.event == Events.savedExcel,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.prompt_SavedExcel)),
            );
          },
        ),
        BlocListener<ScoreBoardCubit, ScoreBoardState>(
          listenWhen: (previous, current) => current.error == Errors.cannotSaveExcel,
          listener: (context, state) {
            showSimpleDialog(context, title: l10n.prompt_CannotSaveExcel);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(courseName),
          actions: hasStudents
              ? const [
                  ExportButton(),
                  SizedBox(width: Spacing.m),
                ]
              : null,
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : hasStudents
                ? const ReadOnlyScoreBoard()
                : Center(child: Text(l10n.scoreboardLabel_NoStudentsYet)),
      ),
    );
  }
}
