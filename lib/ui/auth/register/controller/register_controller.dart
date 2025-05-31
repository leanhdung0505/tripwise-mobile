import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/auth_repository.dart';
import '../../../../data/request/auth/register_request_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_validator.dart';

class RegisterController extends BaseController {
  static RegisterController get to => Get.find<RegisterController>();
  AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isShowConfirmPassword = true.obs;
  Rx<bool> isChecked = false.obs;
  Rx<bool> isRegisterEnabled = false.obs;
  final String? email = Get.arguments;
  final formKey = GlobalKey<FormState>();
  Rx<bool> isLoading = false.obs;
  RxInt currentPage = 2.obs; // Không cần PageController

  @override
  void onInit() {
    super.onInit();
    if (email != null && email!.isNotEmpty) {
      emailController.text = email!;
      usernameController.text = email?.split('@').first ?? "";
      checkButtonStatus();
    }
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final email = emailController.text.trim();
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    isRegisterEnabled.value = AppValidator.validateEmail(email) == null &&
        AppValidator.validatePassword(password) == null &&
        AppValidator.validateConfirmPassword(confirmPassword, password) ==
            null &&
        AppValidator.validateRequired(fullName) == null &&
        AppValidator.validateRequired(username) == null;
  }

  Future<void> onRegister() async {
    if (isRegisterEnabled.value) {
      isLoading.value = true;
      final request = RegisterRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        fullName: fullNameController.text.trim(),
        username: usernameController.text.trim(),
        role: "user",
      );
      subscribe(
        future: _authRepository.register(body: request.toJson()),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            if (response != null) {
              showSimpleSuccessSnackBar(message: "registerSuccess".tr);
              Get.offAllNamed(PageName.loginPage);
            }
          },
          onError: (response) {
            showSimpleErrorSnackBar(message: response.message ?? " ");
          },
        ),
      ).whenComplete(() {
        isLoading.value = false;
      });
    }
  }

  void onNavigateToLogin() {
    Get.offAllNamed(PageName.loginPage);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
