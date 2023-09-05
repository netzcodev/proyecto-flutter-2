class WrongCredential implements Exception {}

class InvalidToken implements Exception {}

class ConnetionTimeOut implements Exception {}

class CustomError implements Exception {
  final String message;
  final int code;

  CustomError(this.message, this.code);
}
