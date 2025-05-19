import 'package:trip_wise_app/common/base/api/response/base_response.dart';

abstract class AiRepository {
  Future<BaseResponse> generateAiPlanner({Map<String, dynamic>? body});
  Future<BaseResponse> generateAiItinerary({Map<String, dynamic>? body});
}
