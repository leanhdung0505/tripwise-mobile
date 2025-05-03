import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/resource/lang/en_us.dart';
import 'package:trip_wise_app/resource/lang/vi_vn.dart';

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'vi_VN': viVN,
      };
}
