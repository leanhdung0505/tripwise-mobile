import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import '../../../../common/base/controller/observer_func.dart';

import '../../../../common/repository/auth_repository.dart';
import '../../../../utils/app_validator.dart';
import '../../../../data/request/auth/request_otp_model.dart';
import '../../../../data/response/auth/request_otp_response.dart';

class ForgotPasswordController extends BaseController {
  static ForgotPasswordController get to =>
      Get.find<ForgotPasswordController>();
  AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  TextEditingController emailController = TextEditingController();
  Rx<bool> isSendButtonEnabled = false.obs;
  Rx<bool> isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  Future<void> onRequestOtp() async {
    if (isSendButtonEnabled.value) {
      isLoading.value = true;
      final email = emailController.text.trim();
      final request = RequestOtpModel(
        email: email,
        purpose: "recovery",
      );
      subscribe(
        future: _authRepository.requestOtp(body: request.toJson()),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            isLoading.value = false;
            if (response != null) {
              final requestOtpResponse =
                  RequestOtpResponse.fromJson(response.body['data']);
              showSimpleSuccessSnackBar(
                  message: requestOtpResponse.message ?? " ");
              Get.toNamed(PageName.verifyCodePage, arguments: {
                "token": requestOtpResponse.token,
                "purpose": "recovery",
                "email": email,
              });
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

  void checkButtonStatus() {
    final email = emailController.text.trim();
    isSendButtonEnabled.value = AppValidator.validateEmail(email) == null;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
