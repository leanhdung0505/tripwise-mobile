import 'package:get/get.dart';

import '../controller/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CalendarController>(CalendarController());
  }
}
