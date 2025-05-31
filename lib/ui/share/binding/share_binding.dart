import 'package:get/get.dart';
import '../../../common/repository/itinerary_repository.dart';
import '../../../common/repository/itinerary_repository_impl.dart';
import '../controller/share_controller.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItineraryRepository>(ItineraryRepositoryImpl());
    Get.put<ShareController>(ShareController());
  }
}