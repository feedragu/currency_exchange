import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String proxy = String.fromEnvironment('PROXY_IP');

Dio appDioBuilder({
  required List<Interceptor> interceptors,
}) {
  final dio = Dio(_baseOptions());
  for (var element in interceptors) {
    dio.interceptors.add(element);
  }
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final HttpClient client = HttpClient();
    if (proxy.isNotEmpty == true) {
      client.findProxy = (uri) {
        return 'PROXY $proxy';
      };
    }
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) =>
            proxy.isNotEmpty == true;
    return client;
  };
  return dio;
}

BaseOptions _baseOptions() => BaseOptions(
      baseUrl: 'https://v6.exchangerate-api.com',
      contentType: Headers.jsonContentType,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    );

@visibleForTesting
dioTest() {
  final dio = Dio(_baseOptions());
  return dio;
}
