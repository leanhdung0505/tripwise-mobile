import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/storage/local_data.dart';
import 'package:trip_wise_app/common/repository/auth_repository.dart';
import 'package:trip_wise_app/common/repository/auth_repository_impl.dart';

import '../../../../routes/app_routes.dart';

const _headerAccept = "Accept";
const _headerAuthorization = 'Authorization';

class ApiInterceptor extends InterceptorsWrapper {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  bool _isRefreshing = false;
  final List<Function()> _retryQueue = [];

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    setHeaderRequest(options);
    return handler.next(options);
  }

  Future<void> setHeaderRequest(RequestOptions options) async {
    options.headers[_headerAccept] = "application/json";
    if (LocalData.shared.isLogged == true) {
      options.headers[_headerAuthorization] =
          'Bearer ${LocalData.shared.tokenData.val}';
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && LocalData.shared.isLogged) {
      final refreshToken = LocalData.shared.refreshTokenData.val;
      if (refreshToken.isEmpty) {
        _handleLogout();
        return handler.next(err);
      }

      // Nếu đang refresh, xếp request vào hàng đợi
      if (_isRefreshing) {
        _retryQueue.add(() async {
          try {
            final dio = Dio();
            final options = err.requestOptions;
            options.headers[_headerAuthorization] =
                'Bearer ${LocalData.shared.tokenData.val}';
            final response = await dio.fetch(options);
            handler.resolve(response);
          } catch (e) {
            handler.next(err);
          }
        });
        return;
      }

      _isRefreshing = true;
      try {
        final response =
            await _authRepository.refreshToken(refreshToken: refreshToken);
        if (response.status == "OK" && response.body != null) {
          // Lưu lại token mới
          LocalData.shared.tokenData.val = response.body['access_token'];
          LocalData.shared.refreshTokenData.val =
              response.body['refresh_token'];
          final dio = Dio();
          final options = err.requestOptions;
          options.headers[_headerAuthorization] =
              'Bearer ${LocalData.shared.tokenData.val}';
          final retryResponse = await dio.fetch(options);
          handler.resolve(retryResponse);
          for (final retry in _retryQueue) {
            await retry();
          }
          _retryQueue.clear();
        } else {
          _handleLogout();
          handler.next(err);
        }
      } catch (e) {
        _handleLogout();
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
      return;
    }
    return handler.next(err);
  }

  void _handleLogout() {
    LocalData.shared.tokenData.val = '';
    LocalData.shared.refreshTokenData.val = '';
    LocalData.shared.user = null;
    Get.offAllNamed(PageName.loginPage);
  }
}
