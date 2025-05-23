import 'package:get/get.dart';
import 'package:trip_wise_app/ui/plan/map/controller/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MapController>(MapController());
  }
}
