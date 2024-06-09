import 'package:tools/tools.dart';

enum Events {
  none,
  loggedIn,
  loggedOut,
  gotCurrentUser,
  gotUsers,
  createdUser,
  updatedUser,
  deletedUser,
  gotCourses,
  createdCourse,
  updatedCourseInfo,
  deletedCourse,
  gotScoreboard,
  gotStudents,
  updatedCourseScore,
  updatedCourseFinalScore,
  @Deprecated('Use update course score instead.')
  updatedCourseScores,
  createdAssignment,
  updatedAssignment,
  deletedAssignment,
  @Deprecated('Use update course info instead.')
  updatedCourseStudentList,
  gotStudentCourseScore,
  generatedMidtermScore,
  publishedMidtermScore,
  generatedFinalScore,
  publishedFinalScore,
  gotStudentScoreReport,
  savedExcel,
  ;

  @override
  toString() => name;
  toJson() => name;
  bool matches(String? value) => name == value;
}

enum Errors {
  none,
  loginBanned,
  invalidCredentials,
  validationError,
  methodNotAllowed,
  unauthorized,
  permissionDenied,
  invalidArguments,
  emptyRequest,
  notFound,
  unknown,
  cannotCalculate,
  cannotSaveExcel,
  insufficientAssignmentList,
  unimplemented,
  ;

  @override
  String toString() => name;
  String toJson() => name;
  bool matches(String? value) => name == value;
}

class ValidationErrors {
  ValidationErrors._(this.code, [this.detail]);

  factory ValidationErrors.fromJson(Json json) {
    try {
      return ValidationErrors._(ValidationError.values.byName(json['code']), json['detail']);
    } on ArgumentError {
      return ValidationErrors._(ValidationError.unknown);
    }
  }

  factory ValidationErrors.none() => ValidationErrors._(ValidationError.none);
  factory ValidationErrors.fieldRequired() => ValidationErrors._(ValidationError.fieldRequired);
  factory ValidationErrors.tooWeak() => ValidationErrors._(ValidationError.tooWeak);
  factory ValidationErrors.tooShort(int count) => ValidationErrors._(ValidationError.tooShort, count);
  factory ValidationErrors.tooLong(int count) => ValidationErrors._(ValidationError.tooLong, count);
  factory ValidationErrors.outOfRange() => ValidationErrors._(ValidationError.outOfRange);
  factory ValidationErrors.duplicated(DuplicationFields field) => ValidationErrors._(ValidationError.duplicated, field);
  factory ValidationErrors.invalidPassword() => ValidationErrors._(ValidationError.invalidPassword);
  factory ValidationErrors.samePasswords() => ValidationErrors._(ValidationError.samePasswords);
  @Deprecated('Use ValidationErrors.duplicated instead.')
  factory ValidationErrors.sameUserNames() => ValidationErrors._(ValidationError.sameUserNames);
  factory ValidationErrors.unknown() => ValidationErrors._(ValidationError.unknown);
  factory ValidationErrors.byName(String name) => ValidationErrors.fromJson({'code': name});

  final ValidationError code;
  final dynamic detail;

  @override
  String toString() => code.name;
  Json toJson() => {
        'code': code,
        'detail': detail,
      };
}

enum ValidationError {
  none,
  fieldRequired,
  tooWeak,
  tooShort,
  tooLong,
  outOfRange,
  duplicated,
  invalidPassword,
  samePasswords,
  sameUserNames,
  unknown,
  ;

  @override
  String toString() => name;
  String toJson() => name;
  bool matches(String? value) => name == value;
}

enum DuplicationFields {
  userName,
  courseName,
  assignmentName,
  assignmentType,
  user;

  @override
  toString() => name;
  toJson() => name;
}
