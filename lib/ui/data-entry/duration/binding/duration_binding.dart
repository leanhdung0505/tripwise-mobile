import 'package:get/get.dart';
import '../controller/duration_controller.dart';

class DurationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DurationController>(DurationController());
  }
}