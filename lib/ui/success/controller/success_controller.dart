import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

class SuccessController extends BaseController{
  static SuccessController get to => Get.find<SuccessController>();

  @override
  void onInit() {
    super.onInit();
  }
  void onBackToLogin() {
    Get.offAllNamed(PageName.loginPage);
  }
  @override
  void onClose() {
    super.onClose();
  }
}