import 'package:trip_wise_app/common/base/api/response/base_response.dart';

abstract class ItineraryRepository {
  Future<BaseResponse> getListItinerary({int page, int limit});
  Future<BaseResponse> getDetailItinerary(int id);
}
