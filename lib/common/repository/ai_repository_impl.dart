import 'package:trip_wise_app/common/base/api/response/base_response.dart';
import 'package:trip_wise_app/common/repository/ai_repository.dart';

import '../base/api/api_service.dart';

class AiRepositoryImpl implements AiRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<BaseResponse> generateAiPlanner({Map<String, dynamic>? body}) async {
    return _apiService.postUriData(
      url: 'http://128.199.225.104/api/v1/trip/generate_trip_plan',
      data: body,
    );
  }

  @override
  Future<BaseResponse> generateAiItinerary({Map<String, dynamic>? body}) async {
    return _apiService.postData(
      endPoint: "/api/v1/itinerary-planner/create-from-ai",
      data: body,
    );
  }
}
