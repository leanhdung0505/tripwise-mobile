import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/auth_repository.dart';
import '../../../../data/request/auth/reset_password_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_validator.dart';

class ResetPasswordController extends BaseController {
  static ResetPasswordController get to => Get.find<ResetPasswordController>();
  AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final String? email = Get.arguments;
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isShowConfirmPassword = true.obs;
  Rx<bool> isSubmitButtonEnabled = false.obs;
  Rx<bool> isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  
  // Không cần PageController vì không có PageView trong trang này
  RxInt currentPage = 2.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    isSubmitButtonEnabled.value = AppValidator.validatePassword(password) ==
            null &&
        AppValidator.validateConfirmPassword(confirmPassword, password) == null;
  }

  Future<void> onResetPassword() async {
    if (isSubmitButtonEnabled.value) {
      isLoading.value = true;
      final password = passwordController.text.trim();
      final request = ResetPasswordModel(
        email: email,
        newPassword: password,
      );
      subscribe(
        future: _authRepository.resetPassword(
          body: request.toJson(),
        ),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            isLoading.value = false;
            if (response != null) {
              showSimpleSuccessSnackBar(
                  message: response.body["detail"] ?? " ");
              Get.toNamed(PageName.successPage);
            }
          },
          onError: (response) {
            isLoading.value = false;
            showSimpleErrorSnackBar(message: response.message ?? " ");
          },
        ),
      ).whenComplete(() {
        isLoading.value = false;
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}