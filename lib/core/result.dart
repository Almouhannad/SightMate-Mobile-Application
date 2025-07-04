class Result<T> {
  T? value;
  String? error;
  final bool isSuccess;
  final bool? hasValidationErrors;
  final List<String>? validationErrors;
  Result({
    required this.isSuccess,
    this.value,
    this.error,
    this.hasValidationErrors,
    this.validationErrors,
  });
}
