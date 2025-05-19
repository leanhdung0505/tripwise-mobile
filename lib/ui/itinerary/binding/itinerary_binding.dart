import 'package:get/get.dart';

import '../controller/itinerary_controller.dart';

class ItineraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItineraryController>(ItineraryController());
  }
}
