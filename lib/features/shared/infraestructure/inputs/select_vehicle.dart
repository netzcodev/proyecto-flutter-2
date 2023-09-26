import 'package:formz/formz.dart';

// Define input validation errors
enum SelectVehicleError { empty }

// Extend FormzInput and provide the input type and error type.
class SelectVehicle extends FormzInput<int, SelectVehicleError> {
  // Call super.pure to represent an unmodified form input.
  const SelectVehicle.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const SelectVehicle.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SelectVehicleError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SelectVehicleError? validator(int value) {
    if (value <= 0) return SelectVehicleError.empty;

    return null;
  }
}
