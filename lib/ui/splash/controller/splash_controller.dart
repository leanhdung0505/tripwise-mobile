import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/storage/local_data.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import 'package:trip_wise_app/utils/extension_utils.dart';

import '../../../common/base/controller/base_controller.dart';

class SplashController extends BaseController {
  static SplashController get to => Get.find<SplashController>();

  @override
  void onInit() {
    super.onInit();
    getCommon();
  }

  Future<void> getCommon() async {
    navigateToHome();
  }

  Future<void> navigateToHome() async {
    Future.delayed(Duration(seconds: random(1, 2)), () async {
      onNavigate();
    });
  }

  void onNavigate() {
    if (LocalData.shared.isLogged.isTrue) {
      Get.offAllNamed(PageName.loginPage);
    } else {
      Get.offAllNamed(PageName.loginPage);
    }
  }
}
