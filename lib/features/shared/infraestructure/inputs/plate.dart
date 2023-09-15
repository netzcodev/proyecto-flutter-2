import 'package:formz/formz.dart';

// Define input validation errors
enum PlateError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Plate extends FormzInput<String, PlateError> {
  static final RegExp plateRegExp = RegExp(
    r'^[A-Z]{3}\d{3}$',
  );

  // Call super.pure to represent an unmodified form input.
  const Plate.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Plate.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PlateError.empty) return 'El campo es requerido';
    if (displayError == PlateError.format) {
      return 'No tiene formato de placa colombiana';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PlateError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PlateError.empty;
    if (!plateRegExp.hasMatch(value)) return PlateError.format;

    return null;
  }
}
