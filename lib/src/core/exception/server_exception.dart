import 'package:currency_exchange/src/core/exception/app_exception.dart';

class ServerException implements AppException {
  final int? statusCode;

  ServerException({this.statusCode});

  @override
  String toString() => 'ServerException: (Status code: $statusCode)';
}
