import 'package:trip_wise_app/common/base/api/api_service.dart';
import 'package:trip_wise_app/common/base/api/response/base_response.dart';
import 'package:trip_wise_app/common/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<BaseResponse> login({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.login, data: body);
  }
}

class Endpoint {
  static const login = '/api/v1/login/';
}
