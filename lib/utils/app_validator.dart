import 'package:get/get.dart';

class AppValidator {
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return "thisFieldIsRequired".tr;
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "thisFieldIsRequired".tr;
  }

  final phoneRegExp = RegExp(r'^\d{10}$');
  if (!phoneRegExp.hasMatch(value)) {
    return "invalidPhoneNumber".tr;
  }
  return null;
}


  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "requiredEmail".tr;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "errorEmail".tr;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'requiredPass'.tr;
    }
    if (value.length < 8) {
      return 'errorPass'.tr;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'requiredPass'.tr;
    }
    if (value.length < 6) {
      return 'errorPass'.tr;
    }
    if (value != password) {
      return 'passwordNotMatch'.tr;
    }
    return null;
  }
}
