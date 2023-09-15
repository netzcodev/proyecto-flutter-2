import 'package:formz/formz.dart';

enum FuelError { empty, type }

const fuelValues = ['gasolina', 'acpm', 'extra'];

class Fuel extends FormzInput<String, FuelError> {
  const Fuel.pure() : super.pure('');

  const Fuel.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == FuelError.empty) return 'El campo es requerido';
    if (displayError == FuelError.type) return 'Tipo de combustible inválido';

    return null;
  }

  @override
  FuelError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty || value == '') {
      return FuelError.empty;
    }

    if (!fuelValues.contains(value)) return FuelError.type;

    return null;
  }
}
