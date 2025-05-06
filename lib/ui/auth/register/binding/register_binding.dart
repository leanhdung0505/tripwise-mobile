import 'package:get/get.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../common/repository/auth_repository_impl.dart';
import '../controller/register_controller.dart';

class RegisterBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
    Get.put<AuthRepository>(AuthRepositoryImpl());
  }
}