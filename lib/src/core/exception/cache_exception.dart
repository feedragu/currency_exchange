import 'package:currency_exchange/src/core/exception/app_exception.dart';

class CacheException implements AppException {

  CacheException();

  @override
  String toString() => 'CacheException';
}
