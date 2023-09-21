import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

// Define input validation errors
enum TimeError { empty }

// Extend FormzInput and provide the input type and error type.
class CustomTime extends FormzInput<TimeOfDay, TimeError> {
  // Call super.pure to represent an unmodified form input.
  const CustomTime.pure() : super.pure(const TimeOfDay(hour: 0, minute: 0));

  // Call super.dirty to represent a modified form input.
  const CustomTime.dirty(TimeOfDay value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TimeError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TimeError? validator(TimeOfDay value) {
    if (value.hour == 0 && value.minute == 0) return TimeError.empty;
    if (value.hour == 0) return TimeError.empty;

    return null;
  }
}
