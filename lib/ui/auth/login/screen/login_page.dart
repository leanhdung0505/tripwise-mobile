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
import '../controller/login_controller.dart';

class LoginPage extends BasePage<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  Text(
                    "signIn".tr,
                    style: AppStyles.STYLE_32_BOLD.copyWith(
                      color: AppColors.color3461FD,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "signInDescription".tr,
                    style: AppStyles.STYLE_14.copyWith(
                      color: AppColors.color7C8BA0,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _buildInputSection(),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.onNavigateForgotPasswordPage,
                      child: Text(
                        "forgotPassword".tr,
                        style: AppStyles.STYLE_14.copyWith(
                          color: AppColors.color7C8BA0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Obx(
                    () => AppButton(
                      text: "signInButton".tr,
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.onLogin,
                      bgColor: AppColors.color3461FD,
                      height: 60.h,
                      borderRadius: BorderRadius.circular(14.r),
                      unEnabled: !controller.isLoginButtonEnabled.value,
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
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: AppColors.colorF5F9FE,
                            side:
                                const BorderSide(color: AppColors.transparent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SvgPicture.asset(
                                  AppImages.icFacebook,
                                  height: 24.h,
                                  width: 24.w,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Facebook',
                                style: AppStyles.STYLE_14.copyWith(
                                  color: AppColors.color7C8BA0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: AppColors.colorF5F9FE,
                            side:
                                const BorderSide(color: AppColors.transparent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SvgPicture.asset(
                                  AppImages.icGoogle,
                                  height: 24.h,
                                  width: 24.w,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Google',
                                style: AppStyles.STYLE_14.copyWith(
                                  color: AppColors.color7C8BA0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don'tHaveAnAccount".tr,
                        style: AppStyles.STYLE_14.copyWith(
                          color: AppColors.color7C8BA0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.onNavigateRegisterPage();
                        },
                        child: Text(
                          "signUpNow".tr,
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
            Positioned(
              top: 60.h,
              right: 30.w,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  controller.changeLanguage(value);
                },
                icon: const Icon(
                  Icons.language,
                  color: AppColors.color3461FD,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  const PopupMenuItem(
                    value: 'vi',
                    child: Text('Tiếng Việt'),
                  ),
                ],
              ),
            ),
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
          AppTextFiled(
            controller: controller.emailController,
            height: 60.h,
            isRequired: false,
            textInputAction: TextInputAction.done,
            hintText: "enterYourEmail".tr,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
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
        ],
      ),
    );
  }
}
