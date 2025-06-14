import 'package:trip_wise_app/common/base/api/response/base_response.dart';

abstract class ItineraryRepository {
  Future<BaseResponse> getListItinerary({int page, int limit});
  Future<BaseResponse> postItinerary({Map<String, dynamic>? body});
  Future<BaseResponse> getDetailItinerary(int id);
  Future<BaseResponse> updateItinerary(int id, {Map<String, dynamic>? body});
  Future<BaseResponse> deleteItinerary(int id);

  //Day Itinerary
  Future<BaseResponse> addDayItinerary(int id, {Map<String, dynamic>? body});
  Future<BaseResponse> updateDayItinerary(int id, {Map<String, dynamic>? body});
  Future<BaseResponse> deleteDayItinerary(int id);

  //Activity Itinerary
  Future<BaseResponse> addActivityItinerary(int id,
      {Map<String, dynamic>? body});
  Future<BaseResponse> updateActivityItinerary(int id,
      {Map<String, dynamic>? body});
  Future<BaseResponse> deleteActivityItinerary(int id);

  //Share Itinerary
  Future<BaseResponse> shareItinerary({Map<String, dynamic>? body});
  Future<BaseResponse> getSharedItinerary({int page, int limit});
  Future<BaseResponse> updateSharedUserPermission({Map<String, dynamic>? body});

  //Favorite Itinerary
  Future<BaseResponse> addToFavoriteItinerary(int id);
  Future<BaseResponse> removeFromFavoriteItinerary(int id);
  Future<BaseResponse> getFavoriteItinerary({int page, int limit});
}
