class AppException implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final _message;
  // ignore: prefer_typing_uninitialized_variables
  final _prefix;

  AppException([this._message, this._prefix]);

  dynamic get getMessage {
    return _message;
  }

  @override
  String toString() {
    return '$_prefix --> $_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message, 'Bad Request Exception');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(message, 'Unauthorised Exception');
}

class PaymentRequiredException extends AppException {
  PaymentRequiredException([String? message])
      : super(message, 'Payment Required Exception');
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message, 'Forbidden Exception');
}

class InternetServerException extends AppException {
  InternetServerException([String? message])
      : super(message, 'Internet Server Exception');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input');
}

class MethodNotAllowedException extends AppException {
  MethodNotAllowedException([String? message])
      : super(message, 'Method not allowed Exception');
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, 'Not found Exception');
}

class NotAcceptableException extends AppException {
  NotAcceptableException([String? message])
      : super(message, 'Not acceptable Exception');
}

class UnsupportMediaTypeException extends AppException {
  UnsupportMediaTypeException([String? message])
      : super(message, 'Unsupport media type Exception');
}

class NotImplementedException extends AppException {
  NotImplementedException([String? message])
      : super(message, 'Not implemented Exception');
}

class RequestTimeoutException extends AppException {
  RequestTimeoutException([String? message])
      : super(message, 'Request Timeout Exception');
}

class NotFoundDeviceTokenException extends AppException {
  NotFoundDeviceTokenException([String? message])
      : super(message, 'Not Found Device Token Exception');
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String? message])
      : super(message, 'Service unavailable Exception');
}
