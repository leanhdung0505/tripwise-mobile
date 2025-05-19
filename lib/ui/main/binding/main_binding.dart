import 'package:get/get.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository_impl.dart';
import 'package:trip_wise_app/ui/home/controller/home_controller.dart';
import 'package:trip_wise_app/ui/main/controller/main_controller.dart';

import '../../personal/setting/controller/setting_controller.dart';
import '../../share/controller/share_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItineraryRepository>(ItineraryRepositoryImpl());
    Get.put<MainController>(MainController());
    Get.put<HomeController>(HomeController());
    Get.put<SettingController>(SettingController());
    Get.put<ShareController>(ShareController());
  }
}
