// class ValidationError {
//   ValidationError(this.code, [this.detail]);

//   final String code;
//   final dynamic detail;
// }
import 'package:tools/tools.dart';

Map<String, ValidationErrors> toValidationError(Json rawErrors) {
  final errors = <String, ValidationErrors>{};

  for (final rawError in rawErrors.entries) {
    try {
      errors[rawError.key] = ValidationErrors.fromJson(rawError.value as Json);
    } on ArgumentError {
      print('UNKNOWN ERROR ${rawError.value}');
      errors[rawError.key] = ValidationErrors.unknown();
    }
  }
  
  return errors;
}
