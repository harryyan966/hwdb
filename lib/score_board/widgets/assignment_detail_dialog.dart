import 'package:client_tools/client_tools.dart';
import 'package:flutter/material.dart';
import 'package:hw_dashboard/l10n/l10n.dart';

void showAssignmentDetailDialog(BuildContext context, Assignment assignment) {
  final l10n = context.l10n;

  showSimpleDialog(
    context,
    title: '${EnumString.assignmentType(context, assignment.type)}: ${assignment.name}',
    content: Text(l10n.scoreboardLabel_DueBy(assignment.dueDate)),
  );
}
