import 'package:formz/formz.dart';

enum MileageError { empty }

class Mileage extends FormzInput<int, MileageError> {
  const Mileage.pure() : super.pure(0);

  const Mileage.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MileageError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  MileageError? validator(int value) {
    if (value == 0) {
      return MileageError.empty;
    }

    return null;
  }
}
