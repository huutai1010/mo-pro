class ErrorEtravel {
  String? message;
  Null? errors;
  int? statusCode;

  ErrorEtravel({this.message, this.errors, this.statusCode});

  ErrorEtravel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errors = json['errors'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['errors'] = errors;
    data['statusCode'] = statusCode;
    return data;
  }
}
