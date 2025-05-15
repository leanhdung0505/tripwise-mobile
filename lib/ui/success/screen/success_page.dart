import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart'; 
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/ui/success/controller/success_controller.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/common/base/widgets/app_button.dart';

class SuccessPage extends BasePage<SuccessController> {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rive Animation Success
            SizedBox(
              height: 200.h,
              width: 200.h,
              child: const RiveAnimation.asset(
                AppImages.animationCheck,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              "successTitle".tr,
              style: AppStyles.STYLE_24_BOLD.copyWith(
                color: AppColors.color3461FD,
              ),
            ),
            SizedBox(height: 8.h),

            // Subtitle
            Text(
              "successDescription".tr,
              textAlign: TextAlign.center,
              style: AppStyles.STYLE_14.copyWith(
                color: AppColors.color7C8BA0,
              ),
            ),
            SizedBox(height: 32.h),

            // Continue Button
            AppButton(
              text: "successButton".tr,
              onPressed: controller.onBackToLogin,
              bgColor: AppColors.color3461FD,
              textColor: AppColors.white,
              height: 50.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ),
      ),
    );
  }
}
