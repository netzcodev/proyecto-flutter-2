import 'package:formz/formz.dart';

// Define input validation errors
enum SelectEmployeeError { empty }

// Extend FormzInput and provide the input type and error type.
class SelectEmployee extends FormzInput<int, SelectEmployeeError> {
  // Call super.pure to represent an unmodified form input.
  const SelectEmployee.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const SelectEmployee.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SelectEmployeeError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SelectEmployeeError? validator(int value) {
    if (value <= 0) return SelectEmployeeError.empty;

    return null;
  }
}
