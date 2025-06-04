import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/data/request/auth/request_otp_model.dart';
import 'package:trip_wise_app/data/request/auth/verify_otp_model.dart';
import 'package:trip_wise_app/data/response/auth/verify_otp_response.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/auth_repository.dart';
import '../../../../data/response/auth/request_otp_response.dart';
import '../../../../routes/app_routes.dart';
import '../../reset-password/controller/reset_password_controller.dart';
import '../../../../utils/extension_utils.dart';

class VerifyCodeController extends BaseController {
  static ResetPasswordController get to => Get.find<ResetPasswordController>();
  AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  TextEditingController pinCodeController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Rx<bool> isResendButtonEnabled = false.obs;
  Rx<bool> isVerifyButtonEnabled = false.obs;
  final formKey = GlobalKey<FormState>();
  String? token = Get.arguments['token'];
  final String? purpose = Get.arguments['purpose'];
  final String? email = Get.arguments['email'];
  Rx<bool> isLoading = false.obs;
  
  // Không cần PageController vì không thực sự chuyển trang trong UI
  // Chỉ giữ RxInt để hiển thị chỉ báo trang thích hợp
  RxInt currentPage = 1.obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  void setVerificationCode(String? value) =>
      pinCodeController.text = value ?? "";

  void checkSubmit(String value) {
    if (value.length == 5) {
      isVerifyButtonEnabled.value = true;
    } else {
      isVerifyButtonEnabled.value = false;
    }
  }

  Future<void> onVerifyOtp() async {
    if (isVerifyButtonEnabled.value) {
      isLoading.value = true;
      final otpCode = pinCodeController.text.trim();
      final request = VerifyOtpModel(
        otpCode: otpCode,
        token: token,
      );
      subscribe(
        future: _authRepository.verifyCode(body: request.toJson()),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            isLoading.value = false;
            if (response != null) {
              final verifyOtpResponse =
                  VerifyOtpResponse.fromJson(response.body['data']);
              showSimpleSuccessSnackBar(
                  message: verifyOtpResponse.message.nullToEmpty);
              if (purpose == "register") {
                Get.toNamed(
                  PageName.registerPage,
                  arguments: verifyOtpResponse.email,
                );
              } else if (purpose == "recovery") {
                Get.toNamed(
                  PageName.resetPasswordPage,
                  arguments: verifyOtpResponse.email,
                );
              }
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
  
  Future<void> onResendOtp() async {
      final request = RequestOtpModel(
        email: email,
        purpose: purpose,
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
              token = requestOtpResponse.token;
              showSimpleSuccessSnackBar(
                  message: requestOtpResponse.message.nullToEmpty);
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
  
  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }
}