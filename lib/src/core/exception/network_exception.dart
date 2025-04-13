import 'package:currency_exchange/src/core/exception/app_exception.dart';

class NetworkException implements AppException {
  NetworkException();

  @override
  String toString() => 'ServerException';
}
