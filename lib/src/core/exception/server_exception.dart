import 'package:currency_exchange/src/core/exception/app_exception.dart';

class ServerException implements AppException {
  @override
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}
