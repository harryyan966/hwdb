import 'package:tools/tools.dart';

abstract class ConversionTools {
  ConversionTools._();

  static List<Json> toJsonList(dynamic value) {
    return (value as List).map((e) => e as Json).toList();
  }

  static List<T> toJsonTypeList<T>(dynamic value, T Function(Json) fromJson) {
    return (value as List).map((e) => e as Json).map((e) => fromJson(e)).toList();
  }

  static Scores toScores(dynamic value) {
    return (value as Json).map((k, v) {
      if (v is double) {
        return MapEntry(k, v);
      }
      if (v is int) {
        return MapEntry(k, v.toDouble());
      }
      if (v == null) {
        return MapEntry(k, null);
      }
      return MapEntry(k, double.tryParse(v));
    });
  }

  static MultiScores toMultiScores(dynamic value) {
    return (value as Json).map((k, v) => MapEntry(k, toScores(v)));
  }
}
