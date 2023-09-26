import 'package:formz/formz.dart';

// Define input validation errors
enum SelectCustomerError { empty }

// Extend FormzInput and provide the input type and error type.
class SelectCustomer extends FormzInput<int, SelectCustomerError> {
  // Call super.pure to represent an unmodified form input.
  const SelectCustomer.pure() : super.pure(0);

  // Call super.dirty to represent a modified form input.
  const SelectCustomer.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SelectCustomerError.empty) {
      return 'El campo es requerido';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SelectCustomerError? validator(int value) {
    if (value <= 0) return SelectCustomerError.empty;

    return null;
  }
}
