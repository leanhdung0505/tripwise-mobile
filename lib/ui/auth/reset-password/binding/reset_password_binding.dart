import 'package:get/get.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../common/repository/auth_repository_impl.dart';
import '../controller/reset_password_controller.dart';

class ResetPasswordBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<ResetPasswordController>(ResetPasswordController());
    Get.put<AuthRepository>(AuthRepositoryImpl());
  }
}