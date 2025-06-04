import 'package:trip_wise_app/common/base/api/api_service.dart';
import 'package:trip_wise_app/common/base/api/response/base_response.dart';
import 'package:trip_wise_app/common/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<BaseResponse> login({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.login, data: body);
  }

  @override
  Future<BaseResponse> register({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.register, data: body);
  }

  @override
  Future<BaseResponse> forgotPassword({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.forgotPassword, data: body);
  }

  @override
  Future<BaseResponse> resetPassword({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.resetPassword, data: body);
  }

  @override
  Future<BaseResponse> verifyCode({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.verifyCode, data: body);
  }

  @override
  Future<BaseResponse> requestOtp({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.requestOtp, data: body);
  }

  @override
  Future<BaseResponse> googleSignIn({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.googleSignIn, data: body);
  }

  @override
  Future<BaseResponse> logout() {
    return _apiService.postData(endPoint: Endpoint.logout,);
  }
}

class Endpoint {
  static const login = '/api/v1/login/';
  static const register = '/api/v1/register/';
  static const forgotPassword = '/api/v1/forgot-password/';
  static const resetPassword = '/api/v1/password/reset-by-email';
  static const verifyCode = '/api/v1/otp/verify';
  static const requestOtp = '/api/v1/otp/request';
  static const googleSignIn = '/api/v1/google/login';
  static const logout = '/api/v1/logout';
}
