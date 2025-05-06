import 'package:get/get.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../common/repository/auth_repository_impl.dart';
import '../controller/request_otp_controller.dart';

class RequestOtpBinding  extends Bindings{
  @override
  void dependencies() {
    Get.put<RequestOtpController>(RequestOtpController());
    Get.put<AuthRepository>(AuthRepositoryImpl());
  }
}