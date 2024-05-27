import 'package:flutter/material.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

abstract class EnumString {
  EnumString._();

  static String userRole(BuildContext context, UserRole userRole) {
    final l10n = context.l10n;

    return switch (userRole) {
      UserRole.admin => l10n.userRole_Admin,
      UserRole.teacher => l10n.userRole_Teacher,
      UserRole.student => l10n.userRole_Student,
      UserRole.none => throw Exception('Empty user converted to enum string.')
    };
  }

  static String assignmentType(BuildContext context, AssignmentType assignmentType) {
    final l10n = context.l10n;

    return switch (assignmentType) {
      AssignmentType.homework => l10n.assignmentType_Homework,
      AssignmentType.quiz => l10n.assignmentType_Quiz,
      AssignmentType.midtermExam => l10n.assignmentType_Midterm,
      AssignmentType.finalExam => l10n.assignmentType_FinalExam,
      AssignmentType.participation => l10n.assignmentType_Participation,
      AssignmentType.none => throw Exception('Empty assignment converted to enum string.'),
    };
  }

  static String grade(BuildContext context, Grade grade) {
    final l10n = context.l10n;

    return switch (grade) {
      Grade.g10fall => l10n.grade_G10fall,
      Grade.g10spring => l10n.grade_G10spring,
      Grade.g11fall => l10n.grade_G11fall,
      Grade.g11spring => l10n.grade_G11spring,
      Grade.g12fall => l10n.grade_G12fall,
      Grade.g12spring => l10n.grade_G12spring,
      Grade.none => throw Exception('Empty grade converted to enum string.'),
    };
  }

  static String scoreRecordType(BuildContext context, ScoreRecordType type) {
    final l10n = context.l10n;

    return switch (type) {
      ScoreRecordType.midtermRecord => l10n.scoreRecordType_MidtermRecord,
      ScoreRecordType.finalRecord => l10n.scoreRecordType_FinalRecord,
    };
  }
}
