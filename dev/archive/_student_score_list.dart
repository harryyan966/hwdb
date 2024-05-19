// child: Table(
//                   children: [
//                     TableRow(
//                       children: [
//                         LegendCell(l10n.scoreBoardLabel_Assignment),
//                         TitleCell(l10n.scoreBoardLabel_AssignmentType, fillColor: colorScheme.secondaryContainer),
//                         TitleCell(l10n.scoreBoardLabel_DueDate, fillColor: colorScheme.secondaryContainer),
//                         TitleCell(l10n.scoreBoardLabel_Score, fillColor: colorScheme.primaryContainer),
//                       ],
//                     ),
//                     for (final assignment in assignments)
//                       TableRow(
//                         children: [
//                           TitleCell(assignment.name, fillColor: colorScheme.secondaryContainer),
//                           ContentCell(toAssignmentTypeString(context, assignment.type)),
//                           ContentCell(DateFormat.yMd().format(assignment.dueDate)),
//                           ScoreCell(score: scores[assignment.id]),
//                         ],
//                       )
//                   ],
//                 ),