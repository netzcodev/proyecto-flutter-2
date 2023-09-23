import 'package:formz/formz.dart';

// Define input validation errors
enum DurationServiceError { empty }

// Extend FormzInput and provide the input type and error type.
class DurationService extends FormzInput<int, DurationServiceError> {
  // Call super.pure to represent an unmodified form input.
  const DurationService.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const DurationService.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DurationServiceError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DurationServiceError? validator(int value) {
    if (value <= 0) return DurationServiceError.empty;

    return null;
  }
}
