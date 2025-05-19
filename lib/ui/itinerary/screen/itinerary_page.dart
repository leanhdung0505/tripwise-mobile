import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/common/base/widgets/app_dash_line.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/ui/itinerary/screen/widget/item_distance_widget.dart';

import '../../../resource/theme/app_colors.dart';
import '../controller/itinerary_controller.dart';
import 'widget/item_activity_widget.dart';

class ItineraryPage extends BasePage<ItineraryController> {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final RxBool isScrolled = false.obs;

    scrollController.addListener(() {
      if (scrollController.offset > 10.h && !isScrolled.value) {
        isScrolled.value = true;
      } else if (scrollController.offset <= 10.h && isScrolled.value) {
        isScrolled.value = false;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.colorF5F9FE,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                _buildHeader(),
                // Destination info card
                _buildCardInformation(),
                _buildTimeline(),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 70.h,
                width: double.infinity,
                padding: isScrolled.value
                    ? EdgeInsets.symmetric(horizontal: 18.w)
                    : EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: isScrolled.value
                      ? AppColors.white
                      : AppColors.transparent,
                  boxShadow: isScrolled.value
                      ? [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: isScrolled.value
                            ? AppColors.transparent
                            : AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: isScrolled.value
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: InkWell(
                        onTap: controller.onNavigatePreviousPage,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SvgPicture.asset(
                            AppImages.icArrowLeft,
                            height: 24.h,
                            width: 24.h,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: isScrolled.value
                            ? AppColors.transparent
                            : AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: isScrolled.value
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: InkWell(
                        onTap: controller.onNavigatePreviousPage,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SvgPicture.asset(
                            AppImages.icMap,
                            height: 24.h,
                            width: 24.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.earth),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.black.withOpacity(0.5),
              AppColors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInformation() {
    return Transform.translate(
      offset: Offset(0, -70.h),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black80.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    controller.destination.value.name,
                    style: AppStyles.STYLE_20_BOLD.copyWith(
                        color: AppColors.color0C092A, fontSize: 22.sp),
                  ),
                ),
                SvgPicture.asset(
                  AppImages.icMenu,
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.destination.value.country,
                    style: AppStyles.STYLE_14
                        .copyWith(color: AppColors.color0C092A),
                  ),
                  Text(
                    "${controller.destination.value.startDate} - ${controller.destination.value.endDate}",
                    style: AppStyles.STYLE_14
                        .copyWith(color: AppColors.color0C092A),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.person, color: Colors.white, size: 18.sp),
                ),
                SizedBox(width: 8.w),
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: Colors.grey,
                  child:
                      Icon(Icons.person_add, color: Colors.white, size: 16.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (context, index) {
          final isEven = index % 2 == 0;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator with line
              _buildTimelineIndicator(isEven, index == 8),
              SizedBox(
                width: 16.w,
              ),
              // Content (activity or distance)
              Expanded(
                child: isEven
                    ? const ItemActivityWidget()
                    : const ItemDistanceWidget(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimelineIndicator(bool isActivity, bool isLast) {
    return Column(
      children: [
        // Icon circle
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: AppColors.color3461FD.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              isActivity ? AppImages.icLocationTick : AppImages.icRouting,
              height: 20.h,
              width: 20.w,
            ),
          ),
        ),
        // Dash line (not shown for the last item)
        if (!isLast)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: CustomPaint(
              size: Size(2.w, isActivity ? 320.h : 40.h),
              painter: AppDashLine(
                color: AppColors.color3461FD.withOpacity(0.2),
                dashHeight: 6,
                dashSpace: 6,
              ),
            ),
          ),
      ],
    );
  }
}
