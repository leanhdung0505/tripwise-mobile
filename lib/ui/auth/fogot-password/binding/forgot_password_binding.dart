import 'package:get/get.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../common/repository/auth_repository_impl.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ForgotPasswordController>(ForgotPasswordController());
    Get.put<AuthRepository>(AuthRepositoryImpl());
  }
}