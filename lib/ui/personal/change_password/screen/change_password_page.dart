import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/common/base/widgets/app_button.dart';
import 'package:trip_wise_app/common/base/widgets/app_text_field.dart';
import 'package:trip_wise_app/common/base/widgets/custom_app_bar.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/utils/app_validator.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordPage extends BasePage<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: 'changePassword'.tr,
          showLeading: true,
          onTap: Get.back,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'changePasswordDescription'.tr,
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color7C8BA0,
                  ),
                ),
                SizedBox(height: 32.h),
                _buildPasswordFields(),
                SizedBox(height: 32.h),
                Obx(
                  () => AppButton(
                    text: 'changePassword'.tr,
                    onPressed: controller.onChangePassword,
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
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        // Old Password Field
        Obx(
          () => AppTextFiled(
            controller: controller.oldPasswordController,
            isRequired: true,
            textInputAction: TextInputAction.next,
            height: 60.h,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            hintText: 'enterOldPassword'.tr,
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
                controller.isShowOldPassword.value =
                    !controller.isShowOldPassword.value;
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                  controller.isShowOldPassword.value
                      ? AppImages.icEyeSlash
                      : AppImages.icEye,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
            obscureText: controller.isShowOldPassword.value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'thisFieldIsRequired'.tr;
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 16.h),
        // New Password Field
        Obx(
          () => AppTextFiled(
            controller: controller.newPasswordController,
            isRequired: true,
            textInputAction: TextInputAction.next,
            height: 60.h,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            hintText: 'enterNewPassword'.tr,
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
                controller.isShowNewPassword.value =
                    !controller.isShowNewPassword.value;
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SvgPicture.asset(
                  controller.isShowNewPassword.value
                      ? AppImages.icEyeSlash
                      : AppImages.icEye,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
            obscureText: controller.isShowNewPassword.value,
            validator: AppValidator.validatePassword,
          ),
        ),
        SizedBox(height: 16.h),
        // Confirm New Password Field
        Obx(
          () => AppTextFiled(
            controller: controller.confirmPasswordController,
            isRequired: true,
            textInputAction: TextInputAction.done,
            height: 60.h,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
            hintText: 'confirmNewPassword'.tr,
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
              controller.newPasswordController.text.trim(),
            ),
          ),
        ),
      ],
    );
  }
}
