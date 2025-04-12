import 'package:currency_exchange/src/core/exception/app_exception.dart';

class CacheException implements AppException {
  @override
  final String? message;

  CacheException({this.message});

  @override
  String toString() => 'CacheException: $message';
}
