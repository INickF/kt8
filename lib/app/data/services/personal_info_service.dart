import 'package:authexample/app/data/models/tokens/tokens.dart';
import 'package:authexample/app/data/services/storage_service.dart';
import 'package:authexample/app/data/services/user_service.dart';
import 'package:authexample/app/data/static/static.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Response;

class PersonalInfoService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final _userService = Get.find<UserService>();
  final _httpClient = Dio();

  PersonalInfoService() {
    _httpClient.options.baseUrl = "$baseUrl/users/";
    _httpClient.options.headers.addAll({"ngrok-skip-browser-warning": "1"});
    _httpClient.options.connectTimeout = const Duration(seconds: 5);
    _httpClient.options.receiveTimeout = const Duration(seconds: 3);

    _httpClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.startsWith("http")) {
            options.path = options.baseUrl + options.path;
          }
          Tokens? tokens = await _storageService.readTokens();
          String access = tokens?.accessToken ?? "";
          options.headers["Authorization"] = "Bearer $access";
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            debugPrint('ProductService: Connection timed out');
            handler.next(error);
          } else if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
            if (await _userService.refresh()) {
              try {
                handler.resolve(await _retry(error.requestOptions));
              } on DioException {
                handler.next(error);
              }
            }
          } else {
            debugPrint('ProductService error: ${error.message}');
            handler.next(error);
          }
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _httpClient.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

    Future<String?> getPersonalInfo() async {
    try {
      Response response = await _httpClient.get("/");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException {
      _storageService.deleteTokens();
      return null;
    }
    return null;
  }
}