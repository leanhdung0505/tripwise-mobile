import 'package:get/get.dart';
import 'package:trip_wise_app/ui/data-entry/process_loading/controller/process_loading_controller.dart';

class ProcessLoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProcessLoadingController>(ProcessLoadingController());
  }
}
