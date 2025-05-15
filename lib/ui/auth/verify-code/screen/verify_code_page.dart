import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/widgets/app_pin_code.dart';
import 'package:trip_wise_app/common/base/widgets/custom_app_bar.dart';
import 'package:trip_wise_app/utils/extension_utils.dart';

import '../../../../common/base/controller/base_page_widget.dart';
import '../../../../common/base/widgets/app_button.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';
import '../controller/verify_code_controller.dart';

class VerifyCodePage extends BasePage<VerifyCodeController> {
  const VerifyCodePage({super.key});

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
                      "verifyCodeTitle".tr, 
                      style: AppStyles.STYLE_32_BOLD.copyWith(
                        color: AppColors.color3461FD,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            softWrap: true,
                            maxLines: null,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "verifyCodeDescription"
                                      .tr, 
                                  style: AppStyles.STYLE_14.copyWith(
                                    color: AppColors.color7C8BA0,
                                  ),
                                ),
                                TextSpan(
                                  text: controller.email.format.nullToEmpty,
                                  style: AppStyles.STYLE_14.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    AppPinCode(
                      controller: controller.pinCodeController,
                      focusNode: controller.focusNode,
                      onCompleted: controller.setVerificationCode,
                      onChanged: controller.checkSubmit,
                    ),
                    SizedBox(height: 32.h),
                    Obx(
                      () => AppButton(
                        text: "verifyCodeButton".tr, 
                        onPressed: controller.onVerifyOtp,
                        bgColor: AppColors.color3461FD,
                        height: 60.h,
                        unEnabled: !controller.isVerifyButtonEnabled.value,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "didNotGetOtp".tr, 
                          style: AppStyles.STYLE_14.copyWith(
                            color: AppColors.color7C8BA0,
                          ),
                        ),
                        InkWell(
                          onTap: controller.onResendOtp,
                          child: Text(
                            "resend".tr, 
                            style: AppStyles.STYLE_14.copyWith(
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
