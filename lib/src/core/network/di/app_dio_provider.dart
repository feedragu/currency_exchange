import 'package:currency_exchange/src/core/network/app_dio_builder.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

const appDioKey = 'app_dio';

SingleChildWidget get dioProvider => Provider<Dio>(
      create: (context) => appDioBuilder(
        interceptors: [],
      ),
    );
