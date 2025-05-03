import 'package:get/get.dart';
import 'package:trip_wise_app/ui/main/controller/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController());
  }
}
