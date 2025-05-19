import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../resource/theme/app_colors.dart';

class AppDivider {

  AppDivider._();

  static dividerWidget() {
    return Divider(
      color: AppColors.colorF5F9FE,
      height: 1.h,
    );
  }
}
