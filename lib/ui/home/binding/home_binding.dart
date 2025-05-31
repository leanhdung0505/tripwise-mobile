import 'package:get/get.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository_impl.dart';

import '../../../common/repository/itinerary_repository.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItineraryRepository>(ItineraryRepositoryImpl());
    Get.put<HomeController>(HomeController());
  }
}
