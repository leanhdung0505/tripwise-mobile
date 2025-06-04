import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trip_wise_app/services/fcm_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    Get.put<FCMService>(FCMService(), permanent: true);
  }
}
