class ApiException {
  final String message;
  final int statusCode;
  Map<String, List<String>>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    required this.errors,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) => ApiException(
        message: json['message'],
        statusCode: json['statusCode'],
        errors: (json['errors'] as Map?)?.map(
          (key, value) => MapEntry(
            key,
            (value as List).map((item) => item as String).toList(),
          ),
        ),
      );
}
