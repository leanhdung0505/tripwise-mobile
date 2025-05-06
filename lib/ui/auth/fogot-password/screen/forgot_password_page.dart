import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/common/base/widgets/custom_app_bar.dart';

import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/app_text_field.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';
import '../../../../utils/app_validator.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordPage extends BasePage<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          showLeading: true,
          onTap: Get.back,
          showShadow: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24.w).copyWith(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: AppStyles.STYLE_32_BOLD.copyWith(
                        color: AppColors.color3461FD,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum.',
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color7C8BA0,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    AppTextFiled(
                      controller: controller.emailController,
                      height: 60.h,
                      isRequired: false,
                      textInputAction: TextInputAction.done,
                      hintText: "enterYourEmail".tr,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.h, horizontal: 24.w),
                      onChanged: controller.onTextChanged,
                      prefixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          AppImages.icSms,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      validator: AppValidator.validateEmail,
                    ),
                    SizedBox(height: 32.h),
                    Obx(
                      () => AppButton(
                        text: 'Send OTP',
                        onPressed: controller.onRequestOtp,
                        bgColor: AppColors.color3461FD,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(14.r),
                        unEnabled: !controller.isSendButtonEnabled.value,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Dots Indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 8.h,
                    width: controller.currentPage.value == index ? 35.w : 8.w,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.color3461FD
                          : AppColors.color7C8BA0.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
