import 'dart:convert';

import 'package:tools/tools.dart';

class JsonFieldFailure implements Exception {
  const JsonFieldFailure(this.message);
  final String message;
  @override
  String toString() => 'JsonFieldFailure: $message';
}

extension JsonX on Json {
  String pretty() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}

extension JsonListX on List<Json> {
  String pretty() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}

enum PageStatus { loading, good, bad }

extension PageStatusX on PageStatus {
  bool get isLoading => this == PageStatus.loading;
  bool get isGood => this == PageStatus.good;
  bool get isBad => this == PageStatus.bad;
  bool get isNotLoading => this != PageStatus.loading;
}
