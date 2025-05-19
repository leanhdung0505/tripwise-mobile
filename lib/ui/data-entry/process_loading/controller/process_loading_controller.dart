import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'dart:async';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/ai_repository.dart';
import '../../../../common/repository/ai_repository_impl.dart';
import '../../../../data/request/itinerary/generate_ai_itinerary.dart';
import '../../../../routes/app_routes.dart';

class ProcessLoadingController extends BaseController {
  static ProcessLoadingController get to =>
      Get.find<ProcessLoadingController>();
  final AiRepository _aiRepository = AiRepositoryImpl();

  final RxDouble progress = 0.0.obs;
  Timer? _timer;
  static const double firstPhaseTarget = 45.0;
  static const double secondPhaseTarget = 95.0;
  static const double progressIncrement = 1.0; 

  @override
  void onInit() {
    super.onInit();
    startFirstPhaseProgress();
  }

  void startFirstPhaseProgress() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      // Tăng duration
      if (progress.value < firstPhaseTarget) {
        progress.value += progressIncrement;
        progress.refresh(); // Force refresh UI
      }
    });
  }

  void startSecondPhaseProgress() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      // Tăng duration
      if (progress.value < secondPhaseTarget) {
        progress.value += progressIncrement;
        progress.refresh(); // Force refresh UI
      }
    });
  }

  Future<void> onGenerateAiPlanner() async {
    subscribe(
      future: _aiRepository.generateAiPlanner(
        body: {
          'budget_category': Get.arguments['budget'],
          'interests': Get.arguments['selectedInterests'],
          'duration': Get.arguments['days'],
          'destination_city': "Da Nang",
        },
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          startSecondPhaseProgress();
          onGenerateAiItinerary(response.body);
        },
        onError: (error) {
          _timer?.cancel();
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
    );
  }

  Future<void> onGenerateAiItinerary(response) async {
    final request = GenerateAiItineraryModel(
      title: "Trip to Da Nang",
      description: "This is a trip to Da Nang by generated from AI",
      startDate: Get.arguments['startDate'],
      endDate: Get.arguments['endDate'],
      budgetCategory: Get.arguments['budget'],
      duration: Get.arguments['days'],
      destinationCity: "Da Nang",
      hotelId: response['hotel_id'],
      days: (response['days'] as List<dynamic>?)
          ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    subscribe(
      future: _aiRepository.generateAiItinerary(
        body: request.toJson(),
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
            if (progress.value >= 100) {
              timer.cancel();
              onNavigateItineraryPage(response.body['itinerary_id']);
            } else {
              progress.value += progressIncrement;
              progress.refresh(); 
            }
          });
        },
        onError: (error) {
          _timer?.cancel();
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
    );
  }

  void onNavigateItineraryPage(int itineraryId) {
    Get.offNamedUntil(
      PageName.itineraryPage,
      (route) => route.settings.name == PageName.mainPage,
      arguments: {
        'startDate': Get.arguments['startDate'],
        'endDate': Get.arguments['endDate'],
        'itineraryId': itineraryId,
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
