import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/utils/app_validator.dart';
import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/app_text_field.dart';
import '../../../../common/base/widgets/base_page_widget.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';
import '../controller/register_controller.dart';

class RegisterPage extends BasePage<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              Text(
                "signUp".tr,
                style: AppStyles.STYLE_32_BOLD.copyWith(
                  color: AppColors.color3461FD,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "signUpDescription".tr,
                style: AppStyles.STYLE_14.copyWith(
                  color: AppColors.color7C8BA0,
                ),
              ),
              SizedBox(height: 32.h),
              _buildInputSection(),
              SizedBox(height: 32.h),
              Obx(
                () => AppButton(
                  text: "signUpButton".tr,
                  onPressed: controller.onRegister,
                  bgColor: AppColors.color3461FD,
                  height: 60.h,
                  borderRadius: BorderRadius.circular(14.r),
                  unEnabled: !controller.isRegisterEnabled.value,
                  isLoading: controller.isLoading.value,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.color7C8BA0.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "or".tr,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color7C8BA0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.color7C8BA0.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "doYouHaveAnAccount".tr,
                    style: AppStyles.STYLE_14.copyWith(
                      color: AppColors.color7C8BA0,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.onNavigateToLogin,
                    child: Text(
                      "signIn".tr,
                      style: AppStyles.STYLE_16_BOLD.copyWith(
                        color: AppColors.color3461FD,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          AppTextFiled(
            controller: controller.emailController,
            height: 60.h,
            isRequired: false,
            isReadOnly: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            hintText: "enterYourEmail".tr,
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
          SizedBox(height: 12.h),
          AppTextFiled(
            controller: controller.usernameController,
            hintText: "enterYourUsername".tr,
            isRequired: false,
            textInputAction: TextInputAction.done,
            height: 60.h,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            onChanged: controller.onTextChanged,
            prefixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              child: SvgPicture.asset(
                AppImages.icPerson,
                height: 24.h,
                width: 24.w,
              ),
            ),
            validator: AppValidator.validateRequired,
          ),
          SizedBox(height: 12.h),
          AppTextFiled(
            controller: controller.fullNameController,
            isRequired: false,
            textInputAction: TextInputAction.done,
            height: 60.h,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            hintText: "enterYourFullName".tr,
            onChanged: controller.onTextChanged,
            prefixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              child: SvgPicture.asset(
                AppImages.icPerson,
                height: 24.h,
                width: 24.w,
              ),
            ),
            validator: AppValidator.validateRequired,
          ),
          SizedBox(height: 12.h),
          Obx(
            () => AppTextFiled(
              controller: controller.passwordController,
              isRequired: false,
              textInputAction: TextInputAction.done,
              height: 60.h,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
              hintText: "enterYourPassword".tr,
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
              hintText: "enterYourConfirmPassword".tr,
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
