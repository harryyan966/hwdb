class Field<T> {
  Field([this.value, this.error]) : hasBeenEdited = false;

  T? value;
  String? error;
  bool hasBeenEdited;

  void update(T? value) {
    this.value = value;
    this.error = null;
    this.hasBeenEdited = true;
  }

  bool get noErrors => error == null;
  T? get newValue => hasBeenEdited ? value : null;
}

// class ConstField<T> {
//   const ConstField([this.value])
//       : error = null,
//         hasBeenEdited = false;
//   const ConstField._(this.value, this.error, this.hasBeenEdited);

//   final T? value;
//   final String? error;
//   final bool hasBeenEdited;

//   ConstField<T> updated(T? value) {
//     return ConstField._(value, null, true);
//   }

//   bool get noErrors => error == null;
//   T? get newValue => hasBeenEdited ? value : null;
// }

bool noErrorsIn(List<Field> fields) {
  return fields.every((e) => e.error == null);
}
