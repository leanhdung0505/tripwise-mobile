import 'package:trip_wise_app/common/base/api/response/base_response.dart';

import '../base/api/api_service.dart';
import 'place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final ApiService _apiService = ApiService();
  @override
  Future<BaseResponse> getListPlace(
      {int page = 1, int limit = 10, String? type}) {
    return _apiService.getData(
        endPoint: Endpoint.getListPlace,
        query: {'page': page, 'limit': limit, 'type': type});
  }

  @override
  Future<BaseResponse> searchPlace(
      {String query = '', int skip = 0, int limit = 10, String type = ''}) {
    return _apiService.getData(
        endPoint: Endpoint.searchPlace,
        query: {'query': query, 'skip': skip, 'limit': limit, 'type': type});
  }
}

class Endpoint {
  static const getListPlace = 'api/v1/places';
  static const searchPlace = 'api/v1/places/search';
}
