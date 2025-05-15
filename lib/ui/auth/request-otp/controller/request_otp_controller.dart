import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/data/response/auth/request_otp_response.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/auth_repository.dart';
import '../../../../data/request/auth/request_otp_model.dart';
import '../../../../utils/app_validator.dart';

class RequestOtpController extends BaseController {
  static RequestOtpController get to => Get.find<RequestOtpController>();
  final AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  final TextEditingController emailController = TextEditingController();
  final Rx<bool> isSubmitButtonEnabled = false.obs;
  Rx<bool> isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final RxInt currentPage = 0.obs; // Không cần PageController
  @override
  void onInit() {
    super.onInit();
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final email = emailController.text.trim();
    isSubmitButtonEnabled.value = AppValidator.validateEmail(email) == null;
  }

  Future<void> onRequestOtp() async {
    if (isSubmitButtonEnabled.value) {
      isLoading.value = true;
      final email = emailController.text.trim();
      final request = RequestOtpModel(
        email: email,
        purpose: "register",
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
                "purpose": "register",
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

  @override
  void onClose() {
    super.onClose();
  }
}
