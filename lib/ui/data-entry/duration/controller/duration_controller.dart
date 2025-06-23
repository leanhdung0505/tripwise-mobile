import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

class DurationController extends BaseController {
  static DurationController get to => Get.find<DurationController>();
  RxInt days = 0.obs;
  RxBool isEnabledButton = false.obs;
  @override
  void onInit() {
    super.onInit();
    // Initialize your controller here
  }

  void incrementDays() {
    days.value++;
    if (days.value > 30) {
      days.value = 30;
    }
    checkStatus();
  }

  void decrementDays() {
    if (days.value > 0) {
      days.value--;
      checkStatus();
    }
  }

  void checkStatus() {
    isEnabledButton.value = days.value > 0;
  }

  void onNext() {
    Get.toNamed(PageName.calendarPage, arguments: {
      "days": days.value - 1,
    });
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources here
  }
}
