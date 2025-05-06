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
import '../controller/reset_password_controller.dart';

class ResetPasswordPage extends BasePage<ResetPasswordController> {
  const ResetPasswordPage({super.key});

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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w).copyWith(
                  top: 0.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reset Password',
                      style: AppStyles.STYLE_32_BOLD.copyWith(
                        color: AppColors.color3461FD,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Please enter your new password and confirm it below.',
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color7C8BA0,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildInputSection(),
                    SizedBox(height: 32.h),
                    Obx(
                      () => AppButton(
                        text: 'Submit',
                        onPressed: controller.onResetPassword,
                        bgColor: AppColors.color3461FD,
                        height: 60.h,
                        borderRadius: BorderRadius.circular(14.r),
                        unEnabled: !controller.isSubmitButtonEnabled.value,
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

  Widget _buildInputSection() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => AppTextFiled(
              controller: controller.passwordController,
              isRequired: false,
              textInputAction: TextInputAction.done,
              height: 60.h,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
              hintText: "Enter your new password",
              onChanged: controller.onTextChanged,
              prefixIcon: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                  AppImages.icKey,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
              suffixIcon: InkWell(
                onTap: () {
                  controller.isShowPassword.value =
                      !controller.isShowPassword.value;
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    controller.isShowPassword.value
                        ? AppImages.icEyeSlash
                        : AppImages.icEye,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
              ),
              obscureText: controller.isShowPassword.value,
              validator: AppValidator.validatePassword,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => AppTextFiled(
              controller: controller.confirmPasswordController,
              isRequired: false,
              textInputAction: TextInputAction.done,
              height: 60.h,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
              hintText: "Confirm your new password",
              onChanged: controller.onTextChanged,
              prefixIcon: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                  AppImages.icKey,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
              suffixIcon: InkWell(
                onTap: () {
                  controller.isShowConfirmPassword.value =
                      !controller.isShowConfirmPassword.value;
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    controller.isShowConfirmPassword.value
                        ? AppImages.icEyeSlash
                        : AppImages.icEye,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
              ),
              obscureText: controller.isShowConfirmPassword.value,
              validator: (value) => AppValidator.validateConfirmPassword(
                value,
                controller.passwordController.text.trim(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}