import '../base/api/response/base_response.dart';

abstract class PlaceRepository {
  Future<BaseResponse> getListPlace({int page, int limit, String? type});
  Future<BaseResponse> searchPlace({String query, int skip, int limit, String type});
}
