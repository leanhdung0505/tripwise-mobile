import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/common/base/widgets/app_dash_line.dart';
import 'package:trip_wise_app/data/model/itinerary/day_model.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/ui/plan/itinerary/screen/widget/day_tab_widget.dart';
import 'package:trip_wise_app/ui/plan/itinerary/screen/widget/item_distance_widget.dart';
import 'package:trip_wise_app/ui/plan/itinerary/screen/widget/itinerary_shimmer_loading.dart';
import '../../../../common/base/widgets/custom_bottom_sheet.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../utils/date_time_utils.dart';
import '../controller/itinerary_controller.dart';
import 'widget/item_activity_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

    return Obx(
      () {
        if (controller.isLoading.value) {
          return const ItineraryShimmerLoading();
        }

        return Scaffold(
          backgroundColor: AppColors.colorF5F9FE,
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    _buildHeaderWithCard(context),
                    _buildDayTabs(),
                    SizedBox(height: 16.h),
                    _buildDayActivities(),
                    SizedBox(height: 20.h),
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
                            onTap: controller.navigateToMapPage,
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
      },
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: Obx(() {
        if (controller.headerImages.isEmpty) {
          // Fallback to default image
          return Container(
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

        return Stack(
          children: [
            // Image carousel
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Container(
                key: ValueKey(controller.currentImageIndex.value),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _getImageProvider(controller
                        .headerImages[controller.currentImageIndex.value]),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                      print('Error loading image: $exception');
                    },
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
              ),
            ),
          ],
        );
      }),
    );
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    // Otherwise, treat as asset image
    return AssetImage(imagePath);
  }

  Widget _buildCardInformation(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -30.h),
      child: Container(
        width: double.infinity,
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
                Expanded(
                  child: Obx(
                    () => Text(
                      controller.itineraryModel.value?.destinationCity ??
                          "daNang".tr,
                      style: AppStyles.STYLE_20_BOLD.copyWith(
                          color: AppColors.color0C092A, fontSize: 22.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () => _showItineraryMenu(context),
                  child: SvgPicture.asset(
                    AppImages.icMenu,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "vietNam".tr,
                      style: AppStyles.STYLE_14
                          .copyWith(color: AppColors.color0C092A),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    flex: 1,
                    child: Text(
                      "${DateTimeUtils.tryParse(controller.itineraryModel.value?.startDate)?.formatMonthDate() ?? ''} - "
                      "${DateTimeUtils.tryParse(controller.itineraryModel.value?.endDate)?.formatMonthDate() ?? ''}",
                      style: AppStyles.STYLE_14
                          .copyWith(color: AppColors.color0C092A),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
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

  Widget _buildHeaderWithCard(BuildContext context) {
    return SizedBox(
      height: 200.h + 90.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildHeader(),
          Positioned(
            left: 25.w,
            right: 25.w,
            bottom: 0,
            child: _buildCardInformation(context),
          ),
        ],
      ),
    );
  }

  // Widget for day tabs
  Widget _buildDayTabs() {
    return Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 20.w),
      child: Obx(() {
        final List<DayModel> days = controller.visibleDays;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          itemBuilder: (context, index) {
            return Obx(
              () => DayTabWidget(
                day: days[index],
                isSelected: controller.selectedDayIndex.value == index,
                onTap: () => controller.selectDay(index),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDayActivities() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() {
        final selectedDay = controller.selectedDay;
        if (selectedDay == null) {
          return Center(
            child: Text(
              'No day selected',
              style: AppStyles.STYLE_16.copyWith(color: AppColors.color0C092A),
            ),
          );
        }

        final activities = selectedDay.activities ?? [];
        final activityCount = activities.length;

        if (activityCount == 0) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Column(
                children: [
                  Icon(
                    Icons.event_note,
                    size: 48.sp,
                    color: AppColors.color3461FD.withOpacity(0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No activities for Day ${selectedDay.dayNumber}',
                    style: AppStyles.STYLE_16
                        .copyWith(color: AppColors.color0C092A),
                  ),
                ],
              ),
            ),
          );
        }

        // For actual data, build activity list with distance widgets between activities
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activityCount * 2 - 1,
          itemBuilder: (context, index) {
            final isEven = index % 2 == 0;
            final activityIndex = isEven ? index ~/ 2 : (index - 1) ~/ 2;

            if (isEven) {
              // Activity item
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineIndicator(true, index == activityCount * 2 - 2),
                  SizedBox(width: 16.w),
                  Expanded(
                    child:
                        ItemActivityWidget(activity: activities[activityIndex],dayNumber: selectedDay.dayNumber,),
                  ),
                ],
              );
            } else {
              final fromActivity = activities[activityIndex];
              final toActivity = activities[activityIndex + 1];
              final String distance = controller
                  .calculateDistanceBetweenActivities(fromActivity, toActivity);
              double distanceValue = 0;
              try {
                final distanceStr = distance.split(' ')[0];
                distanceValue = double.tryParse(distanceStr) ?? 0;
                if (!distance.contains('km')) {
                  distanceValue = distanceValue / 1000;
                }
              } catch (_) {}
              final String travelTime =
                  controller.estimateTravelTime(distanceValue);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineIndicator(false, false),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ItemDistanceWidget(
                      distance: distance,
                      duration: travelTime,
                    ),
                  ),
                ],
              );
            }
          },
        );
      }),
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

  void _showItineraryMenu(BuildContext context) {
    final menuOptions = [
      MenuOption(
        title: 'editPlan'.tr,
        iconPath: AppImages.icEdit,
        onTap: () {
          // Handle edit plan
          // controller.editPlan();
        },
      ),
      MenuOption(
        title: 'sharePlan'.tr,
        iconPath: AppImages.icShare,
        onTap: () {},
      ),
      MenuOption(
        title: 'deletePlan'.tr,
        iconPath: AppImages.icDelete,
        titleColor: Colors.red,
        iconColor: Colors.red,
        onTap: () {
          _showDeleteConfirmation(context);
        },
      ),
    ];
    context.showMenuBottomSheet(
      options: menuOptions,
      // title: 'planOptions'.tr, // Optional title
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      dialogBackgroundColor: AppColors.white,
      btnCancelOnPress: () {},
      btnOkText: 'delete'.tr,
      btnCancelText: 'cancel'.tr,
      btnCancelColor: AppColors.color7C8BA0,
      btnOkColor: AppColors.errorColor,
      btnOkOnPress: () {
        // controller.deletePlan();
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'confirmDelete'.tr,
            style: AppStyles.STYLE_20.copyWith(
              color: AppColors.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'confirmDeleteMessage'.tr,
            textAlign: TextAlign.center,
            style: AppStyles.STYLE_16.copyWith(
              color: AppColors.color0C092A, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).show();
  }
}
