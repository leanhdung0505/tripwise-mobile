import 'package:get/get.dart';
import '../../../../common/repository/user_repository.dart';
import '../../../../common/repository/user_repository_impl.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserRepository>(UserRepositoryImpl());
    Get.put<ChangePasswordController>(ChangePasswordController());
  }
}
