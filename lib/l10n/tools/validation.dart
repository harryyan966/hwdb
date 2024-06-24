import 'package:flutter/material.dart';
import 'package:hw_dashboard/l10n/l10n.dart';
import 'package:tools/tools.dart';

String? toErrorString(BuildContext context, ValidationErrors? validationError) {
  final l10n = context.l10n;

  if (validationError == null) {
    return null;
  }

  return switch (validationError.code) {
    ValidationError.fieldRequired => l10n.validationError_Required,
    ValidationError.outOfRange => l10n.validationError_OutOfRange,
    ValidationError.tooWeak => l10n.validationError_TooWeak,
    ValidationError.unknown => l10n.validationError_UnKnown,
    ValidationError.invalidPassword => l10n.validationError_InvalidPassword,
    ValidationError.samePasswords => l10n.validationError_SamePasswords,
    ValidationError.sameUserNames => l10n.validationError_SameUserNames,

    // REQUIRES FIELDS
    ValidationError.duplicated =>
      l10n.validationError_Duplicated(toDuplicationFieldString(context, validationError.detail)),
    ValidationError.tooLong => l10n.validationError_TooLong(validationError.detail),
    ValidationError.tooShort => l10n.validationError_TooShort(validationError.detail),

    // NONE
    ValidationError.none => null,
  };
}

String toDuplicationFieldString(BuildContext context, String detail) {
  final l10n = context.l10n;

  try {
    final duplicationField = DuplicationFields.values.byName(detail);
    return switch (duplicationField) {
      DuplicationFields.userName => l10n.formLabel_UserName,
      DuplicationFields.courseName => l10n.formLabel_CourseName,
      DuplicationFields.assignmentName => l10n.formLabel_AssignmentName,
      DuplicationFields.user => l10n.formLabel_User,
      DuplicationFields.assignmentType => l10n.scoreBoardLabel_AssignmentType,
      DuplicationFields.className => l10n.formLabel_ClassName,
    };
  } on ArgumentError {
    return 'UNKNOWN FIELD';
  }
}
