import 'package:trip_wise_app/common/base/api/api_service.dart';
import 'package:trip_wise_app/common/base/api/response/base_response.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<BaseResponse> getDetailItinerary(int id) {
    return _apiService.getData(endPoint: '${Endpoint.getDetailItinerary}$id');
  }

  @override
  Future<BaseResponse> getListItinerary({int page = 1, limit = 10}) {
    return _apiService.getData(
        endPoint: Endpoint.getListItinerary,
        query: {'page': page, 'limit': limit});
  }
}

class Endpoint {
  static const getDetailItinerary = 'api/v1/itineraries/';
  static const getListItinerary = 'api/v1/itineraries';
}
