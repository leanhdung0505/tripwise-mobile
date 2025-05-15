import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/common/base/widgets/app_button.dart';
import 'package:trip_wise_app/common/base/widgets/custom_app_bar.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/ui/data-entry/duration/controller/duration_controller.dart';

class DurationPage extends BasePage<DurationController> {
  const DurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _buildAppBar(),
      ),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 34.h),
          child: Column(
            children: [
              _buildTravelDurationRow(),
              SizedBox(height: 10.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "durationDescription".tr,
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color0C092A,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20.h),
              _buildDaySelectionRow(),
              const Spacer(),
              Obx(
                () => AppButton(
                  text: "Next",
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
                          "step".trParams({"step": "1/4"}),
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
                                widthFactor: 1 / 4,
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

  Widget _buildTravelDurationRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.colorE47E0A,
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
            "durationTitle".tr,
            style: AppStyles.STYLE_20_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelectionRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.colorF5F9FE,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: controller.decrementDays,
            child: Container(
              height: 40.h,
              width: 40.h,
              decoration: const BoxDecoration(
                color: AppColors.colorE6E6E6,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: AppColors.black,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          Obx(
            () => Text(
              "day".trParams({"day": controller.days.value.toString()}),
              style: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.color7C8BA0,
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.incrementDays,
            child: Container(
              height: 40.h,
              width: 40.h,
              decoration: const BoxDecoration(
                color: AppColors.colorE6E6E6,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: AppColors.black,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
