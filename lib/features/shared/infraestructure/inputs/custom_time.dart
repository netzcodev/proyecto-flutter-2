import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

// Define input validation errors
enum TimeError { empty, outOfRange } // Paso 1: Añadir nuevo error

class CustomTime extends FormzInput<TimeOfDay, TimeError> {
  const CustomTime.pure() : super.pure(const TimeOfDay(hour: 0, minute: 0));
  const CustomTime.dirty(TimeOfDay value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    switch (error) {
      case TimeError.empty:
        return 'El campo es requerido';
      case TimeError.outOfRange:
        return 'La hora seleccionada no está dentro del rango permitido';
      default:
        return null;
    }
  }

  @override
  TimeError? validator(TimeOfDay value) {
    if (value == const TimeOfDay(hour: 0, minute: 0)) return TimeError.empty;

    if (value.hour < 8 ||
        (value.hour == 16 && value.minute > 0) ||
        value.hour > 16) {
      return TimeError.outOfRange;
    }
    return null;
  }
}
