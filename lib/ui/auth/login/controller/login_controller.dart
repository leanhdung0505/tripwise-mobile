import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../common/repository/auth_repository.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/base/storage/local_data.dart';
import '../../../../data/request/auth/login_request_model.dart';
import '../../../../data/response/auth_response.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_validator.dart';

class LoginController extends BaseController {
  static LoginController get to => Get.find<LoginController>();

  AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isChecked = false.obs;
  Rx<bool> isLoginButtonEnabled = false.obs;
  Rx<bool> isLoading = false.obs; // Thêm trạng thái loading
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  void onNavigateMainPage() {
    if (formKey.currentState?.validate() == false) return;
    Get.offAllNamed(PageName.mainPage);
  }

  void onNavigateForgotPasswordPage() {
    Get.toNamed(PageName.forgotPasswordPage);
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoginButtonEnabled.value = AppValidator.validateEmail(email) == null &&
        AppValidator.validatePassword(password) == null;
  }

  Future<void> onLogin() async {
    if (isLoginButtonEnabled.value) {
      isLoading.value = true; 
      final request = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      subscribe(
        future: _authRepository.login(
          body: request.toJson(),
        ),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            final authResponse = AuthResponse.fromJson(response.body['data']);
            LocalData.shared.tokenData.val = authResponse.accessToken;
            showSimpleSuccessSnackBar(message: "Login Success");
            navigateMain();
          },
          onError: (error) {
            showSimpleErrorSnackBar(message: error.message ?? "");
          },
        ),
        isShowLoading: false, // Không hiển thị loading mặc định
      ).whenComplete(() {
        isLoading.value = false; // Kết thúc loading
      });
    }
  }

  void navigateMain() {
    if (isLoginButtonEnabled.value) {
      Get.toNamed(PageName.mainPage);
    }
  }

  void onNavigateRegisterPage() {
    Get.toNamed(PageName.requestOtp);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
