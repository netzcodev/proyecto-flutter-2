import 'package:formz/formz.dart';

enum VehicleNameError { empty }

class VehicleName extends FormzInput<String, VehicleNameError> {
  const VehicleName.pure() : super.pure('');

  const VehicleName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == VehicleNameError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  VehicleNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty || value == '') {
      return VehicleNameError.empty;
    }

    return null;
  }
}
