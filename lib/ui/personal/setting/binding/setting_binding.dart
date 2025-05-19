import 'package:get/get.dart';
import 'package:trip_wise_app/ui/personal/setting/controller/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingController>(SettingController());
  }
}
