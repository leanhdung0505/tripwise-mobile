import 'package:get/get.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository_impl.dart';

import '../controller/itinerary_controller.dart';

class ItineraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItineraryRepository>(ItineraryRepositoryImpl());
    Get.put<ItineraryController>(ItineraryController());
  }
}
