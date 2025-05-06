import 'package:get/get.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../common/repository/auth_repository_impl.dart';
import '../controller/verify_code_controller.dart';

class VerifyCodeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<VerifyCodeController>(VerifyCodeController());
    Get.put<AuthRepository>(AuthRepositoryImpl());
  }
}