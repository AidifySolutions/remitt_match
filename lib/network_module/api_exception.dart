class ApiException {
  final _message;
  final _prefix;

  ApiException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, "");
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class AuthenticationException extends ApiException {
  AuthenticationException([String? message])
      : super(message, "Authentication Failed: ");
}
