import 'package:currency_exchange/src/core/exception/app_exception.dart';

class NetworkException implements AppException {
  @override
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'ServerException: $message';
}
