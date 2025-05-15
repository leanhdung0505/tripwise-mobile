import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/ui/data-entry/interests/models/interest_model.dart';

import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/custom_app_bar.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';
import '../controller/interests_controller.dart';
import 'widgets/item_interest_widget.dart';

class InterestsPage extends BasePage<InterestsController> {
  const InterestsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _buildAppBar(),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 34.h),
                  child: Column(
                    children: [
                      _buildYourInterestsRow(),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "interestsDescription".tr,
                          style: AppStyles.STYLE_14.copyWith(
                            color: AppColors.color0C092A,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildInterestList(),
                      SizedBox(height: 20.h),
                      Obx(
                        () => AppButton(
                          text: "next".tr,
                          onPressed: controller.onNext,
                          bgColor: AppColors.color3461FD,
                          textColor: AppColors.white,
                          height: 50.h,
                          width: 200.w,
                          borderRadius: BorderRadius.circular(12.r),
                          unEnabled: !controller.isEnabledButton.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      child: CustomAppBar(
        showLeading: true,
        onTap: Get.back,
        fillColor: AppColors.white,
        showShadow: false,
        title: null,
        actions: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40.h,
                      width: 40.h,
                      decoration: const BoxDecoration(
                        color: AppColors.colorE6E6E6,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.black,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "step".trParams({"step": "3/4"}),
                          style: AppStyles.STYLE_14.copyWith(
                            color: AppColors.color3461FD,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: Container(
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: AppColors.colorE6E6E6,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: FractionallySizedBox(
                                widthFactor: 3 / 4,
                                child: Container(
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.color3461FD,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourInterestsRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.color0AE4E4,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.icCalendar,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "interestsTitle".tr,
            style: AppStyles.STYLE_20_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestList() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 20.h, end: 20.h),
      child: Obx(
        () => ListView.builder(
          itemCount: controller.interests.value.listInterest.value.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            InterestModel interestModel =
                controller.interests.value.listInterest.value[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ItemInterestWidget(interestModel),
            );
          },
        ),
      ),
    );
  }
}
