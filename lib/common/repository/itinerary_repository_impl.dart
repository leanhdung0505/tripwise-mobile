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
  Future<BaseResponse> getListItinerary({int page = 1, int limit = 10}) {
    return _apiService.getData(
        endPoint: Endpoint.getListItinerary,
        query: {'page': page, 'limit': limit});
  }

  @override
  Future<BaseResponse> postItinerary({Map<String, dynamic>? body}) {
    return _apiService.postData(
      endPoint: Endpoint.getListItinerary,
      data: body,
    );
  }

  @override
  Future<BaseResponse> updateItinerary(int id, {Map<String, dynamic>? body}) {
    return _apiService.patchData(
      endPoint: '${Endpoint.getDetailItinerary}$id',
      data: body,
    );
  }

  @override
  Future<BaseResponse> deleteItinerary(int id) {
    return _apiService.deleteData(
      endPoint: '${Endpoint.getDetailItinerary}$id',
    );
  }

  // Day Itinerary
  @override
  Future<BaseResponse> addDayItinerary(int id, {Map<String, dynamic>? body}) {
    return _apiService.postData(
      endPoint: '${Endpoint.getDetailItinerary}$id/days',
      data: body,
    );
  }

  @override
  Future<BaseResponse> updateDayItinerary(int id,
      {Map<String, dynamic>? body}) {
    return _apiService.putData(
      endPoint: '${Endpoint.dayItinerary}$id',
      data: body,
    );
  }

  @override
  Future<BaseResponse> deleteDayItinerary(int id) {
    return _apiService.deleteData(
      endPoint: '${Endpoint.dayItinerary}$id',
    );
  }

  // Activity Itinerary
  @override
  Future<BaseResponse> addActivityItinerary(int id,
      {Map<String, dynamic>? body}) {
    return _apiService.postData(
      endPoint: '${Endpoint.dayItinerary}$id/activities',
      data: body,
    );
  }

  @override
  Future<BaseResponse> updateActivityItinerary(int id,
      {Map<String, dynamic>? body}) {
    return _apiService.patchData(
      endPoint: '${Endpoint.activityItinerary}$id',
      data: body,
    );
  }

  @override
  Future<BaseResponse> deleteActivityItinerary(int id) {
    return _apiService.deleteData(
      endPoint: '${Endpoint.activityItinerary}$id',
    );
  }

  @override
  Future<BaseResponse> shareItinerary({Map<String, dynamic>? body}) {
    return _apiService.postData(
      endPoint: Endpoint.shareItinerary,
      data: body,
    );
  }

  @override
  Future<BaseResponse> getSharedItinerary({int page = 1, int limit = 10}) {
    return _apiService.getData(
      endPoint: Endpoint.getSharedItinerary,
      query: {'page': page, 'limit': limit},
    );
  }

  @override
  Future<BaseResponse> updateSharedUserPermission(
      {Map<String, dynamic>? body}) {
    return _apiService.putData(
      endPoint: Endpoint.updateSharedUserPermission,
      data: body,
    );
  }

  @override
  Future<BaseResponse> addToFavoriteItinerary(int id) {
    return _apiService.postData(
      endPoint: '${Endpoint.addToFavoriteItinerary}$id/favorite',
    );
  }

  @override
  Future<BaseResponse> removeFromFavoriteItinerary(int id) {
    return _apiService.deleteData(
      endPoint: '${Endpoint.removeFromFavoriteItinerary}$id/favorite',
    );
  }

  @override
  Future<BaseResponse> getFavoriteItinerary({int page = 1, int limit = 10}) {
    return _apiService.getData(
      endPoint: Endpoint.getFavoriteItinerary,
      query: {'page': page, 'limit': limit},
    );
  }
}

class Endpoint {
  static const getDetailItinerary = 'api/v1/itineraries/';
  static const getListItinerary = 'api/v1/itineraries';
  static const dayItinerary = 'api/v1/itineraries/days/';
  static const activityItinerary = 'api/v1/itineraries/activities/';
  static const shareItinerary = 'api/v1/itinerary-shares';
  static const getSharedItinerary =
      'api/v1/itinerary-shares/me/shared-itineraries';
  static const updateSharedUserPermission =
      '/api/v1/itinerary-shares/permission/bulk-update-permissions';
  static const getFavoriteItinerary = 'api/v1/favorite-itineraries';
  static const addToFavoriteItinerary = 'api/v1/itineraries/';
  static const removeFromFavoriteItinerary = 'api/v1/itineraries/';
}
