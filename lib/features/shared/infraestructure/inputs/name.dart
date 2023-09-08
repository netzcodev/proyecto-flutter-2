import 'package:formz/formz.dart';

enum NameError { empty, format }

class Name extends FormzInput<String, NameError> {
  static final RegExp nameRegExp = RegExp(
    r'^[a-zA-Z]+\s[a-zA-Z]+$',
  );

  const Name.pure() : super.pure('');

  const Name.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameError.empty) return 'El campo es requerido';
    if (displayError == NameError.format) {
      return 'Formato inválido, nombre y apellido';
    }

    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;
    if (!nameRegExp.hasMatch(value)) return NameError.format;

    return null;
  }
}
