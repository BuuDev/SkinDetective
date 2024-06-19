import 'dart:async';
import "package:dio/dio.dart";
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:skin_detective/models/user_info/user_info.dart';
import 'package:skin_detective/services/apis/user/user.dart';
import 'package:skin_detective/services/local_storage.dart';
import 'package:skin_detective/widgets/loading/loading.dart';

import '../providers/app/app.dart';

enum EnvironmentMode { dev, production }

const proxyVersion = 'v2';

const _routesExcludeRefreshToken = [
  '/login',
  '/active-account',
  '/login-facebook',
  '/login-google'
];

class ClientApi {
  Dio init() {
    Dio _dio = Dio();
    _dio.interceptors.add(CustomInterceptors(_dio));

    _dio.options.baseUrl = "http://sd-api.pixelcent.com/$proxyVersion";
    _dio.options.receiveTimeout = 100000;
    return _dio;
  }

  static EnvironmentMode mode() {
    return kDebugMode ? EnvironmentMode.dev : EnvironmentMode.production;
  }
}

class CustomInterceptors extends QueuedInterceptor {
  final Dio _dio;
  CustomInterceptors(this._dio);

  void showLoading() {
    if (_dio.options.headers['isLoading'] ?? true) {
      Loading.show();
    }
  }

  void hideLoading() {
    if (_dio.options.headers['isLoading'] ?? true) {
      Loading.hide();
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint(
      'REQUEST[${options.method}] => PATH: ${options.path}',
    );
    showLoading();
    var accessToken = LocalStorage().token;

    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    hideLoading();
    if (kDebugMode) {
      print("In File: api_client.dart, Line: 21 $response ");
      print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }

    if (response.data['data'] != null &&
        !_routesExcludeRefreshToken.contains(response.requestOptions.path)) {
      response.data = response.data['data'];
    }

    super.onResponse(response, handler);
    return Future.value(response);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    // Do something with response error
    if (GetIt.instance<AppVM>().isLogged && err.response?.statusCode == 401 &&
        !_routesExcludeRefreshToken.contains(err.requestOptions.path)) {
      RequestOptions options = err.response!.requestOptions;
      // RequestOptions options2 = err.requestOptions;
      Options _options = Options(
        method: options.method,
        headers: options.headers,
        extra: options.extra,
      );
      UserInfo info =
          await UserService.client().refreshToken(LocalStorage().token);

      GetIt.instance<AppVM>().refreshSuccess(info);
      _options.headers!["Authorization"] = "Bearer " + info.accessToken!;

      return _dio.request(
        options.path,
        options: _options,
        data: options.data,
        queryParameters: options.queryParameters,
      );
    }

    hideLoading();

    debugPrint('$err');

    if (err.response?.data is String) {
      // NotifyHelper.showSnackBar('Đã xảy ra lỗi, vui lòng thử lại!');
      super.onError(err, handler);
      return Future.error(err);
    }

    Map<String, dynamic>? data = err.response?.data;

    if (data != null) {
      // if (data["error"] != null) {
      //   NotifyHelper.showSnackBar(data['error']);
      // } else if (err.requestOptions.extra['isShowMessage'] ??
      //     true && data["message"] != null) {
      //   // email không tồn tại
      //   NotifyHelper.showSnackBar(data['message']);
      // }
    }

    if (kDebugMode) {
      print("In File: api_client.dart, Line: 39 ${err.response} ");
    }

    super.onError(err, handler);
    return Future.error(err);
  }
}
