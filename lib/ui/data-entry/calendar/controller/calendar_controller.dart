import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

class CalendarController extends BaseController {
  static CalendarController get to => Get.find<CalendarController>();
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxBool isEnabledButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    int duration = Get.arguments['days'] ?? 0;
    endDate.value = startDate.value.add(Duration(days: duration));
    checkStatus(duration);
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
    int duration = Get.arguments['days'] ?? 0;
    endDate.value = startDate.value.add(Duration(days: duration));
    checkStatus(duration);
  }

  void checkStatus(int duration) {
    if (duration == 0) {
      isEnabledButton.value = true;
      return;
    }
    isEnabledButton.value = startDate.value.isBefore(endDate.value);
  }

  void onNext() {
    Get.toNamed(PageName.interestsPage, arguments: {
      'startDate': startDate.value,
      'endDate': endDate.value,
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
