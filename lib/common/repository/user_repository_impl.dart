import 'package:trip_wise_app/common/base/api/api_service.dart';
import 'package:trip_wise_app/common/base/api/response/base_response.dart';
import 'package:trip_wise_app/common/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<BaseResponse> getUser() async {
    return _apiService.getData(endPoint: Endpoint.getUser);
  }

  @override
  Future<BaseResponse> updateUser(Map<String, dynamic> body) async {
    return _apiService.patchData(endPoint: Endpoint.updateUser, data: body);
  }

  @override
  Future<BaseResponse> deleteUser() async {
    return _apiService.deleteData(endPoint: Endpoint.deleteUser);
  }

  @override
  Future<BaseResponse> changePassword(Map<String, dynamic> body) async {
    return _apiService.patchData(endPoint: Endpoint.changePassword, data: body);
  }

  @override
  Future<BaseResponse> searchUsersToShare(
      String query, String itineraryId) async {
    return _apiService.getData(endPoint: Endpoint.searchUsersToShare, query: {
      'query': query,
      'itinerary_id': itineraryId,
    });
  }
}

class Endpoint {
  static const String getUser = '/api/v1/users/me';
  static const String updateUser = '/api/v1/users/me';
  static const String deleteUser = '/api/v1/users/me';
  static const String changePassword = '/api/v1/users/me/password';
  static const String searchUsersToShare =
      '/api/v1/itinerary-shares/search-users-to-share';
}
