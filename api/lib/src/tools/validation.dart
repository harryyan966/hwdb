import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:tools/tools.dart';

abstract class Validate {
  Validate._();

  static void userName(String? name) {
    if (name != null && name.length < 2) {
      throw InvalidField({'name': ValidationErrors.tooShort(2)});
    }
  }

  static void userPassword(String? password) {
    // TODO: hash password
    if (password != null && password.length < 8) {
      throw InvalidField({'password': ValidationErrors.tooWeak()});
    }
  }

  static void courseName(String? name) async {
    if (name != null && name.length < 2) {
      throw InvalidField({'name': ValidationErrors.tooShort(2)});
    }
  }

  static void courseYear(int? year) {
    if (year != null && (year < 2000 || year > DateTime.now().year)) {
      throw InvalidField({'year': ValidationErrors.outOfRange()});
    }
  }

  static void assignmentName(String? name) {
    if (name != null && name.length < 2) {
      throw InvalidField({'name': ValidationErrors.tooShort(2)});
    }
  }

  static void assignmentDueDate(DateTime? dueDate) {
    if (dueDate == null) {
      return;
    }
    // If the due date is before today.
    if (dueDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      throw InvalidField({'dueDate': ValidationErrors.outOfRange()});
    }
  }
}

abstract class Ensure {
  Ensure._();

  // TODO: do we ensure this or not? do we do it in the database instead?
  /// Ensures that the provided user name is not in the database
  static Future<void> userNameNotInDb(
    RequestContext context,
    String? name,
  ) async {
    // Ensure the username is not the current user name.
    final currentUserName = (await context.user).name;
    if (name == currentUserName) {
      throw InvalidField({'name': ValidationErrors.duplicated(DuplicationFields.userName)});
    }

    // Ensure the username does not occur in the database.
    final sameUserNames = await context.db.collection('users').count({'name': name});
    if (sameUserNames != 0) {
      throw InvalidField({'name': ValidationErrors.duplicated(DuplicationFields.userName)});
    }
  }

  /// Ensures that the provided name-grade-year combination is not in the database.
  static Future<void> courseInfoNotInDb(
    RequestContext context,
    String name,
    Grade grade,
    int year,
  ) async {
    // Count documents with the same `name-grade-year` combination.
    final sameCourseNameCount = await context.db.collection('courses').count({
      'name': name,
      'grade': grade.name,
      'year': year,
    });
    if (sameCourseNameCount != 0) {
      throw InvalidField({'name': ValidationErrors.duplicated(DuplicationFields.courseName)});
    }
  }

  /// Ensures that the provided assignment name and unique type are not in the database.
  static Future<void> assignmentInfoNotInDb(
    RequestContext context,
    Id courseId,
    String? name,
    AssignmentType? type,
  ) async {
    // Ensure the request is checking something.
    if (name == null && type == null) {
      return;
    }

    // Get duplicate assignments from the course.
    final getDuplicateAssignmentsRes = await context.db.collection('courses').modernFindOne(
      filter: {
        '_id': courseId,
        '\$or': [
          if (name != null) {'assignments.name': name},
          if (type != null && type.countLimit == 1) {'assignments.type': type.name},
        ],
      },
      projection: {'assignments.\$': 1},
    );

    // If a duplicate assignment is found
    if (getDuplicateAssignmentsRes != null) {
      final duplicateAssignment = getDuplicateAssignmentsRes['assignments'].first;

      // If they duplicate on a name
      if (duplicateAssignment['name'] == name) {
        throw InvalidField({'name': ValidationErrors.duplicated(DuplicationFields.assignmentName)});
      }

      // If they duplicate on a unique type
      else {
        throw InvalidField({'type': ValidationErrors.duplicated(DuplicationFields.assignmentType)});
      }
    }
  }

  /// Ensures that the current user is the teacher of the provided course.
  static Future<void> isCourseTeacher(RequestContext context, Id courseId) async {
    // Get the amount of courses with the current courseId and teacherId.
    final validCourseCount = await context.db.collection('courses').count({
      '_id': courseId,
      'teacherId': (await context.user).id,
    });
    if (validCourseCount != 1) {
      throw Forbidden(Errors.permissionDenied);
    }
  }

  /// Ensures if the current user is an admin.
  static Future<void> isAdmin(RequestContext context) async {
    if ((await context.user).role.isNotAdmin) {
      throw Forbidden(Errors.permissionDenied);
    }
  }

  /// Ensures the current user is either the teacher of the provided course or an admin.
  static Future<void> isCourseTeacherOrAdmin(RequestContext context, Id courseId) async {
    try {
      await isAdmin(context);
    } on Forbidden {
      await isCourseTeacher(context, courseId);
    }
  }

  /// Ensures the provided user has a certain role.
  static Future<void> isUserWithRole(RequestContext context, Id userId, UserRole role) async {
    final count = await context.db.collection('users').count({
      '_id': userId,
      'role': role.name,
    });
    if (count != 1) {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  /// Ensures all the provided users have a certain role.
  static Future<void> areUsersWithRole(RequestContext context, Iterable<Id> userIds, UserRole role) async {
    final count = await context.db.collection('users').count({
      '_id': {r'$in': userIds},
      'role': role.name,
    });
    if (count != userIds.length) {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  /// Ensures all the provided studentIds are of students in the course.
  static Future<void> areStudentsInCourse(RequestContext context, Iterable<Id> studentIds, Id courseId) async {
    final courseMatchRes = await context.db.collection('courses').count({
      '_id': courseId,
      'studentIds': {r'$all': studentIds},
    });
    if (courseMatchRes != 1) {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  /// Ensures that the provided studentId and assignmentId are in the course.
  static Future<void> isStudentAssignmentPairInCourse(
      RequestContext context, Id studentId, Id assignmentId, Id courseId) async {
    final courseMatchRes = await context.db.collection('courses').count({
      '_id': courseId,
      'studentIds': studentId,
      'assignments.id': assignmentId,
    });
    if (courseMatchRes != 1) {
      throw BadRequest(Errors.invalidArguments);
    }
  }

  /// Ensures there are no write errors in a write result.
  static Future<void> hasNoWriteErrors(WriteResult res) async {
    if (res.hasWriteErrors) {
      print(res.writeError?.errmsg);
      print('error type 1');
      throw Exception('Something went wrong.');
    }
    // TODO: removed because we suspect failure is induced whenever nothing is modified in the database, which could happen quite legitimately.
    // if (res.isFailure) {
    //   print(res.errmsg);
    //   print(res.serverResponses);
    //   print('error type 2');
    //   throw Exception('Something went wrong.');
    // }
    if (!res.isAcknowledged) {
      print(res.errmsg);
      print('error type 2');
      throw Exception('Something went wrong.');
    }
  }

  /// Ensures there are no bulk write errors in a bulk write result.
  static Future<void> hasNoBulkWriteErrors(BulkWriteResult res) async {
    if (res.hasWriteErrors) {
      print(res.writeErrors.map((e) => e.errmsg));
      print('error type 1');
      throw Exception('Something went wrong.');
    }
    if (res.isFailure) {
      print(res.errmsg);
      print('error type 2');
      throw Exception('Something went wrong.');
    }
    if (!res.isAcknowledged) {
      print(res.errmsg);
      print('error type 3');
      throw Exception('Something went wrong.');
    }
  }
}
