import 'package:formz/formz.dart';

// Define input validation errors
enum SelectError { empty }

// Extend FormzInput and provide the input type and error type.
class Select extends FormzInput<int, SelectError> {
  // Call super.pure to represent an unmodified form input.
  const Select.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const Select.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SelectError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SelectError? validator(int value) {
    if (value <= 0) return SelectError.empty;

    return null;
  }
}
