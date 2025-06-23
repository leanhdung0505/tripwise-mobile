import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/common/base/storage/local_data.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/auth_repository.dart';

class SettingController extends BaseController {
  final AuthRepository _authRepository = Get.find();
  @override
  void onInit() {
    super.onInit();
  }

  void changeLanguage(String languageCode) {
    Locale locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  void onLogout() {
    subscribe(
      future: _authRepository.logout(),
      observer: ObserverFunc(
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "logoutSuccess".tr);
          LocalData.shared.user = null;
          LocalData.shared.tokenData.val = '';
          Get.offAllNamed(PageName.loginPage);
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.toString());
        },
        onSubscribe: () {},
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
