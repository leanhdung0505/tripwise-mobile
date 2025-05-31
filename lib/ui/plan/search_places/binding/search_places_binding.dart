import 'package:get/get.dart';
import '../controller/search_places_controller.dart';

class SearchPlacesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchPlacesController>(SearchPlacesController());
  }
}
