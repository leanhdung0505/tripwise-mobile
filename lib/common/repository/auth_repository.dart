import 'package:trip_wise_app/common/base/api/response/base_response.dart';

abstract class AuthRepository {
  Future<BaseResponse> login({Map<String, dynamic>? body});
  Future<BaseResponse> register({Map<String, dynamic>? body});
  Future<BaseResponse> forgotPassword({Map<String, dynamic>? body});
  Future<BaseResponse> resetPassword({Map<String, dynamic>? body});
  Future<BaseResponse> verifyCode({Map<String, dynamic>? body});
  Future<BaseResponse> requestOtp({Map<String, dynamic>? body});
  Future<BaseResponse> googleSignIn({Map<String, dynamic>? body});
}
