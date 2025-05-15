import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/ui/data-entry/calendar/controller/calendar_controller.dart';

import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/custom_app_bar.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';

class CalendarPage extends BasePage<CalendarController> {
  const CalendarPage({super.key});
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
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 34.h),
          child: Column(
            children: [
              _buildStartDateRow(),
              SizedBox(height: 10.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "calendarDescription".tr,
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color0C092A,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 72.h),
              _buildCalendarSection(),
              const Spacer(),
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
                          "step".trParams({"step": "2/4"}),
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
                                widthFactor: 1 / 2,
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

  Widget _buildStartDateRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.color0AA3E4,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.icCalendar2,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "calendarTitle".tr,
            style: AppStyles.STYLE_20_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return SizedBox(
      width: double.maxFinite,
      child: Obx(
        () => SizedBox(
          height: 450.h,
          width: double.maxFinite,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              selectedDayHighlightColor: AppColors.color3461FD,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              selectedRangeHighlightColor: AppColors.color3461FD,
              firstDayOfWeek: 1,
              centerAlignModePicker: true,
              selectedDayTextStyle: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.white,
              ),
              monthTextStyle: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.color3B4054,
              ),
              yearTextStyle: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.color3B4054,
              ),
              dayTextStyle: AppStyles.STYLE_16.copyWith(
                color: AppColors.color3B4054,
              ),
              weekdayLabelTextStyle: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.color3B4054.withOpacity(0.5),
              ),
              dayBorderRadius: BorderRadius.circular(15.r),
              controlsTextStyle: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.color3B4054,
              ),
              lastMonthIcon: SvgPicture.asset(
                AppImages.icArrowLeft2,
                height: 20.h,
                width: 20.h,
              ),
              nextMonthIcon: SvgPicture.asset(
                AppImages.icArrowRight2,
                height: 20.h,
                width: 20.h,
              ),
            ),
            value: [
              controller.startDate.value,
              controller.endDate.value,
            ],
            onValueChanged: (values) {
              if (values.isNotEmpty) {
                controller.setStartDate(values[0]);
              }
            },
          ),
        ),
      ),
    );
  }
}
