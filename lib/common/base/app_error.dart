import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../common/base/widgets/base_widgets.dart';

enum AppErrorType {
  network,
  badRequest,
  unauthorized,
  cancel,
  timeout,
  server,
  unknown,
}

class AppError extends BaseCustomWidgets {
  late String? message;
  late AppErrorType type;
  late String? errorData;
  late int? code;
  late Exception? exception;

  AppError(Exception? error) {
    exception = error;
    if (error is DioException) {
      message = error.message ?? '';
      switch (error.type) {
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            type = AppErrorType.network;
          } else {
            type = AppErrorType.unknown;
          }
          message = 'noDataAvailableYet'.tr;
          break;
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          type = AppErrorType.timeout;
          break;
        case DioExceptionType.sendTimeout:
          type = AppErrorType.network;
          break;
        case DioExceptionType.badResponse:
          final response = error.response;
          try {
            if (response != null && response.data != null) {
              // Kiểm tra nếu response chứa trường 'detail'
              if (response.data is Map<String, dynamic> &&
                  response.data['detail'] != null) {
                message = response.data['detail']; // Lấy thông báo từ 'detail'
              } else if (response.data['errors'] != null) {
                // Xử lý nếu có trường 'errors'
                final errors = response.data['errors'];
                if (errors is List && errors.isNotEmpty) {
                  final firstError = errors[0];
                  if (firstError is Map<String, dynamic>) {
                    String originalDetail = firstError['detail'];
                    errorData = firstError['code'];
                    message = originalDetail.tr;
                  }
                }
              }
              code = response.statusCode;
            }
          } catch (e) {
            message = 'noDataAvailableYet'.tr;
          }
          switch (response?.statusCode) {
            case HttpStatus.badRequest:
              type = AppErrorType.badRequest;
              break;
            case HttpStatus.unauthorized:
              type = AppErrorType.unauthorized;
              break;
            case HttpStatus.internalServerError:
            case HttpStatus.badGateway:
            case HttpStatus.serviceUnavailable:
            case HttpStatus.gatewayTimeout:
              type = AppErrorType.server;
              break;
            default:
              type = AppErrorType.unknown;
              break;
          }
          break;
        case DioExceptionType.cancel:
          type = AppErrorType.cancel;
          break;
        default:
          type = AppErrorType.unknown;
      }
    } else {
      type = AppErrorType.unknown;
      message = 'AppError: $error';
    }
  }
}
