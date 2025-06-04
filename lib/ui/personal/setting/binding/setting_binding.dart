import 'package:get/get.dart';
import 'package:trip_wise_app/ui/personal/setting/controller/setting_controller.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../common/repository/auth_repository_impl.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(AuthRepositoryImpl());
    Get.put<SettingController>(SettingController());
  }
}
