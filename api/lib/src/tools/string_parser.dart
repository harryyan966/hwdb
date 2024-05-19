import 'dart:convert';

import 'package:api/api.dart';
import 'package:tools/tools.dart';

class ParseString {
  ParseString._();

  static List<String>? toStringListOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return (jsonDecode(data) as List).map((e) => e as String).toList();
  }

  static List<double?>? toDoubleListOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return (jsonDecode(data) as List).map((e) => double.tryParse(e as String)).toList();
  }

  static List<Id>? toIdListOrNull(String? data) {
    return toStringListOrNull(data)?.map((e) => toId(e)).toList();
  }

  static Id? toIdOrNull(String? data) {
    return data == null ? null : toId(data);
  }

  static int? toIntOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return int.tryParse(data);
  }

  static UserRole? toUserRoleOrNull(String? data) {
    if (data == null) {
      return null;
    }
    try {
      return UserRole.values.byName(data);
    } on ArgumentError {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  static AssignmentType? toAssignmentTypeOrNull(String? data) {
    if (data == null) {
      return null;
    }
    try {
      return AssignmentType.values.byName(data);
    } on ArgumentError {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  static Grade? toGradeOrNull(String? data) {
    if (data == null) {
      return null;
    }
    try {
      return Grade.values.byName(data);
    } on ArgumentError {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  static DateTime? toDateOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return DateTime.tryParse(data);
  }

  static String? toDateStringOrNull(String? data) {
    return toDateOrNull(data)?.toIso8601String();
  }

  static double? toDoubleOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return double.tryParse(data);
  }

  static Scores? toScoresOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return ConversionTools.toScores(jsonDecode(data));
  }

  static MultiScores? toMultiScoresOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return ConversionTools.toMultiScores(jsonDecode(data));
  }

  static bool? toBoolOrNull(String? data) {
    if (data == null) {
      return null;
    }
    return bool.tryParse(data);
  }
}
