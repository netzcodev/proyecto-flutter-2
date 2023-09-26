import 'package:formz/formz.dart';

// Define input validation errors
enum ScheduleNameError { empty, length }

// Extend FormzInput and provide the input type and error type.
class ScheduleName extends FormzInput<String, ScheduleNameError> {
  // Call super.pure to represent an unmodified form input.
  const ScheduleName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ScheduleName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ScheduleNameError.empty) return 'El campo es requerido';

    if (displayError == ScheduleNameError.length) {
      return 'El campo debe tener máximo 20 caracteres';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ScheduleNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return ScheduleNameError.empty;
    if (value.length > 20) return ScheduleNameError.length;
    return null;
  }
}
