import '../base/api/response/base_response.dart';

abstract class UserRepository {
  Future<BaseResponse> getUser();
  Future<BaseResponse> updateUser(Map<String, dynamic> body);
  Future<BaseResponse> deleteUser();
  Future<BaseResponse> changePassword(Map<String, dynamic> body);
  Future<BaseResponse> searchUsersToShare(String query, String itineraryId);
}
