import 'package:get/get.dart';

import '../controller/interests_controller.dart';

class InterestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InterestsController>(InterestsController());
  }
}
