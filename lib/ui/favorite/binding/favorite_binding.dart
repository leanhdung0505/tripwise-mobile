import 'package:get/get.dart';
import '../../../common/repository/itinerary_repository.dart';
import '../../../common/repository/itinerary_repository_impl.dart';
import '../controller/favorite_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ItineraryRepository>(ItineraryRepositoryImpl());
    Get.put<FavoriteController>(FavoriteController());
  }
}
