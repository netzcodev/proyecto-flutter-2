class CustomError implements Exception {
  final String message;
  final bool loogedRequired;

  CustomError(this.message, [this.loogedRequired = false]);
}
