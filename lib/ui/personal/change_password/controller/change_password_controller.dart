import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/common/base/controller/observer_func.dart';
import 'package:trip_wise_app/common/repository/user_repository.dart';
import 'package:trip_wise_app/utils/app_validator.dart';

class ChangePasswordController extends BaseController {
  static ChangePasswordController get to =>
      Get.find<ChangePasswordController>();
  final UserRepository _userRepository = Get.find();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Rx<bool> isShowOldPassword = true.obs;
  Rx<bool> isShowNewPassword = true.obs;
  Rx<bool> isShowConfirmPassword = true.obs;
  Rx<bool> isSubmitButtonEnabled = false.obs;
  Rx<bool> isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    isSubmitButtonEnabled.value = oldPassword.isNotEmpty &&
        AppValidator.validatePassword(newPassword) == null &&
        AppValidator.validateConfirmPassword(confirmPassword, newPassword) ==
            null;
  }

  Future<void> onChangePassword() async {
    if (formKey.currentState?.validate() == true) {
      isLoading.value = true;
      final oldPassword = oldPasswordController.text.trim();
      final newPassword = newPasswordController.text.trim();

      final request = {
        'old_password': oldPassword,
        'new_password': newPassword,
      };

      subscribe(
        future: _userRepository.changePassword(request),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            isLoading.value = false;
            if (response.body?["detail"] == "Password changed successfully") {
              showSimpleSuccessSnackBar(
                  message: "passwordChangedSuccessfully".tr);
              Future.delayed(const Duration(seconds: 1), () {
                Get.back();
              });
            }
          },
          onError: (error) {
            isLoading.value = false;
            showSimpleErrorSnackBar(
                message: error.message ?? "errorOccurred".tr);
          },
        ),
      ).whenComplete(() {
        isLoading.value = false;
      });
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
