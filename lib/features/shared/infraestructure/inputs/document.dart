import 'package:formz/formz.dart';

enum DocumentError { empty, value, format }

class Document extends FormzInput<int, DocumentError> {
  static final RegExp documentRegExp = RegExp(
    r'^[0-9]+$',
  );

  const Document.pure() : super.pure(0);

  const Document.dirty(int value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DocumentError.empty) return 'El campo es requerido';
    if (displayError == DocumentError.format) {
      return 'Formáto inválido, solo numeros';
    }
    if (displayError == DocumentError.value) {
      return 'El campo deber ser mayor a 0';
    }

    return null;
  }

  @override
  DocumentError? validator(int value) {
    if (value.toString().isEmpty || value.toString().trim().isEmpty) {
      return DocumentError.empty;
    }
    if (value <= 0) return DocumentError.value;
    if (!documentRegExp.hasMatch(value.toString())) return DocumentError.value;

    return null;
  }
}
