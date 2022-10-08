/*
* @overview: dio-封装
* @Author: rcc 
* @Date: 2022-04-28 16:08:06 
*/

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:rc_tools/tools/rc_log.dart';

export 'package:dio/dio.dart' show BaseOptions, CancelToken, FormData, MultipartFile;

typedef HttpResult = Map<String, dynamic>;

class RcHttp {
  RcHttp._();

  /// RcHttp是否初始化
  static bool _isInit = false;

  static const String _errorText = 'RcHttp Uninitialized';

  static late Dio _dio;

  /// HTTP初始化
  static void init({
    required BaseOptions options,
    void Function(DioError, ErrorInterceptorHandler)? onError,
    void Function(RequestOptions, RequestInterceptorHandler)? onRequest,
    void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse,
  }) {
    _isInit = true;

    _dio = Dio(options);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: onError,
        onRequest: onRequest,
        onResponse: onResponse,
      ),
    );
  }

  /// get请求
  static Future<HttpResult> get(
    String path, {
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    bool isPrint = false,
  }) async {
    assert(_isInit, _errorText);

    final response = await _dio.get(
      path,
      options: options,
      queryParameters: params,
      cancelToken: cancelToken,
    );

    late HttpResult result;

    if (response.data is String) {
      result = json.decode(response.data);
    } else {
      result = response.data ?? {};
    }

    if (isPrint) {
      RcLog.i(result, 'URL: $path');
    }

    return result;
  }

  /// post请求
  static Future<HttpResult> post(
    String path, {
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? data,
    bool isPrint = false,
  }) async {
    assert(_isInit, _errorText);

    final response = await _dio.post(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );

    late HttpResult result;

    if (response.data is String) {
      result = json.decode(response.data);
    } else {
      result = response.data ?? {};
    }

    if (isPrint) {
      RcLog.i(result, 'URL: $path');
    }

    return result;
  }

  /// upload上传
  static Future<HttpResult> upload(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    bool isPrint = false,
  }) async {
    assert(_isInit, _errorText);

    final response = await _dio.post<HttpResult>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );

    final result = response.data ?? {};

    if (isPrint) {
      RcLog.i(result, 'URL: $path');
    }

    return result;
  }

  /// 图片加载
  static Future<Uint8List> image(
    String path, {
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.get<List<int>>(
      path,
      options: Options(
        responseType: ResponseType.bytes,
      ),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    return Uint8List.fromList(response.data!);
  }

  /// 文件下载
  static Future<bool> download(
    String urlPath,
    String savePath, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.download(
      urlPath,
      savePath,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    return response.statusCode == 200;
  }
}
