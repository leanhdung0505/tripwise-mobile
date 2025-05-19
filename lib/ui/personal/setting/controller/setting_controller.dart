import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/common/base/storage/local_data.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

class SettingController extends BaseController {
  @override
  void onInit() {
    super.onInit();
  }

  void onLogout() {
    LocalData.shared.user = null;
    LocalData.shared.tokenData.val = '';
    Get.offAllNamed(PageName.loginPage);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
