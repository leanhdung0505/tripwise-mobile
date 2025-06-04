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
import '../../../../common/base/storage/local_data.dart';
import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/app_text_field.dart';
import '../../../../common/base/widgets/custom_bottom_sheet.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../utils/date_time_utils.dart';
import '../controller/itinerary_controller.dart';
import 'widget/item_activity_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'widget/hotel_item_widget.dart';

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
          body: RefreshIndicator(
            color: AppColors.color3461FD,
            onRefresh: controller.refreshItineraryList,
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      _buildHeaderWithCard(context),
                      if (controller.itineraryModel.value?.hotel != null)
                        HotelItemWidget(
                          hotel: controller.itineraryModel.value?.hotel,
                        ),
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
                // Owner avatar
                SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: CircleAvatar(
                    backgroundImage: (controller
                                .itineraryModel.value?.owner?.profilePicture !=
                            null)
                        ? NetworkImage(controller
                            .itineraryModel.value!.owner!.profilePicture!)
                        : const AssetImage(AppImages.imageUserDefault)
                            as ImageProvider,
                  ),
                ),
                SizedBox(width: 8.w),
                // Shared users avatars
                Obx(() {
                  final sharedUsers = controller.sharedUsers;
                  final displayCount =
                      sharedUsers.length > 4 ? 4 : sharedUsers.length;

                  return InkWell(
                    onTap: () {
                      if (controller.itineraryModel.value?.owner?.userId ==
                          LocalData.shared.user?.userId) {
                        _showSharedUsersList(context);
                      }
                    },
                    child: Row(
                      children: [
                        // Stack of shared user avatars
                        if (sharedUsers.isNotEmpty)
                          SizedBox(
                            width: displayCount * 20.w +
                                10.w, // Width for overlapping avatars
                            height: 30.h,
                            child: Stack(
                              children: List.generate(displayCount, (index) {
                                return Positioned(
                                  left: index * 20.w,
                                  child: Container(
                                    height: 30.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: (sharedUsers[index]
                                                  .profilePicture !=
                                              null)
                                          ? NetworkImage(sharedUsers[index]
                                              .profilePicture!)
                                          : const AssetImage(
                                                  AppImages.imageUserDefault)
                                              as ImageProvider,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
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
                onDeleteDay: (dayId) =>
                    _showDeleteDayConfirmation(context, dayId),
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
      child: Obx(
        () {
          final selectedDay = controller.selectedDay;
          if (selectedDay == null) {
            return Center(
              child: Text(
                "noDaySelected".tr,
                style:
                    AppStyles.STYLE_16.copyWith(color: AppColors.color0C092A),
              ),
            );
          }

          final activities = selectedDay.activities ?? [];
          final activityCount = activities.length;

          return Column(
            children: [
              // Activities list (if any)
              if (activityCount > 0) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activityCount * 2 - 1,
                  itemBuilder: (context, index) {
                    final isEven = index % 2 == 0;
                    final activityIndex =
                        isEven ? index ~/ 2 : (index - 1) ~/ 2;

                    if (isEven) {
                      // Activity item
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimelineIndicator(
                              true, index == activityCount * 2 - 2),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ItemActivityWidget(
                              activity: activities[activityIndex],
                              dayNumber: selectedDay.dayNumber,
                              activityIndex: activityIndex,
                            ),
                          ),
                        ],
                      );
                    } else {
                      final fromActivity = activities[activityIndex];
                      final toActivity = activities[activityIndex + 1];
                      final String distance =
                          controller.calculateDistanceBetweenActivities(
                              fromActivity, toActivity);
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
                              fromActivity: fromActivity,
                              toActivity: toActivity,
                              activityIndex: activityIndex,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ] else ...[
                // No activities message
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 48.sp,
                          color: AppColors.color3461FD.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "noActivities".trParams(
                              {"day": selectedDay.dayNumber.toString()}),
                          style: AppStyles.STYLE_16
                              .copyWith(color: AppColors.color0C092A),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ],

              // Add Restaurant and Activity buttons (always shown)
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          controller.navigateToSearchPlacesPage("RESTAURANT"),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.05),
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
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: const BoxDecoration(
                                    color: AppColors.colorFF9C41,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AppImages.icRestaurant,
                                    width: 20.w,
                                    height: 20.h,
                                    color: AppColors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.color3461FD,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "restaurant".tr,
                              style: AppStyles.STYLE_16_BOLD.copyWith(
                                color: AppColors.color0C092A,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "addNewRestaurant".tr,
                              style: AppStyles.STYLE_12.copyWith(
                                color: AppColors.color7C8BA0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // Add Activity Container
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          controller.navigateToSearchPlacesPage("ATTRACTION"),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.05),
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
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: const BoxDecoration(
                                    color: AppColors.color3461FD,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    AppImages.icActivity,
                                    width: 20.w,
                                    height: 20.h,
                                    color: AppColors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.color3461FD,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "attraction".tr,
                              style: AppStyles.STYLE_16_BOLD.copyWith(
                                color: AppColors.color0C092A,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "addNewAttraction".tr,
                              style: AppStyles.STYLE_12.copyWith(
                                color: AppColors.color7C8BA0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

  void _showItineraryMenu(BuildContext context) {
    final menuOptions = [
      MenuOption(
        title: 'editHotel'.tr,
        iconPath: AppImages.icEdit,
        onTap: () {
          controller.navigateToSearchPlacesPage("HOTEL");
        },
      ),
      MenuOption(
        title: controller.itineraryModel.value?.isFavorite == true
            ? 'removeFromFavorite'.tr
            : 'addToFavorite'.tr,
        iconPath: controller.itineraryModel.value?.isFavorite == true
            ? AppImages.icHeartSlash
            : AppImages.icLovely,
        iconColor: controller.itineraryModel.value?.isFavorite == true
            ? AppColors.color7C8BA0
            : AppColors.colorFF4D4D,
        titleColor: controller.itineraryModel.value?.isFavorite == true
            ? AppColors.color7C8BA0
            : AppColors.colorFF4D4D,
        onTap: () {
          if (controller.itineraryModel.value?.isFavorite == true) {
            controller.removeFromFavorite();
          } else {
            controller.addToFavorite();
          }
        },
      ),
      controller.itineraryModel.value?.owner?.userId ==
              LocalData.shared.user?.userId
          ? MenuOption(
              title: 'sharePlan'.tr,
              iconPath: AppImages.icShare,
              onTap: () {
                _showShareBottomSheet(context);
              },
            )
          : null,
      controller.itineraryModel.value?.owner?.userId ==
              LocalData.shared.user?.userId
          ? MenuOption(
              title: 'deletePlan'.tr,
              iconPath: AppImages.icDelete,
              titleColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                _showDeleteConfirmation(context);
              },
            )
          : null,
    ];
    context.showMenuBottomSheet(
      options: menuOptions,
    );
  }

  void _showShareBottomSheet(BuildContext context) {
    if (!Get.isRegistered<ItineraryController>()) {
      Get.put(ItineraryController());
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                height: 4.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.colorF5F9FE,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Search header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextFiled(
                        controller: controller.searchController,
                        hintText: 'searchUsers'.tr,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SvgPicture.asset(
                            AppImages.icSearch,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                        onChanged: controller.onSearchChanged,
                        focusedBorderColor: AppColors.transparent,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Text(
                        'cancel'.tr,
                        style: AppStyles.STYLE_16.copyWith(
                          color: AppColors.color3461FD,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Search results
              Expanded(
                child: Obx(() => _buildSearchResults()),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (Get.isRegistered<ItineraryController>()) {
          final controller = Get.find<ItineraryController>();
          controller.searchController.clear(); // clear nếu cần
        }
      });
    });
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
      btnOkOnPress: controller.deleteItinerary,
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

  void _showDeleteDayConfirmation(BuildContext context, int dayId) {
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
      btnOkOnPress: () => controller.deleteDay(dayId),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'confirmDeleteDay'.tr,
            style: AppStyles.STYLE_20.copyWith(
              color: AppColors.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'confirmDeleteDayMessage'.tr,
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

  Widget _buildSearchResults() {
    return Container(
      color: AppColors.white,
      child: controller.searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppImages.icSearch,
                    width: 64.w,
                    height: 64.h,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'noResult'.tr,
                    style: AppStyles.STYLE_14.copyWith(
                      color: AppColors.color7C8BA0,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              controller: controller.scrollController,
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final user = controller.searchResults[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.colorF5F9FE),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Image.network(
                          user.profilePicture ?? AppImages.imageUserDefault,
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.imageUserDefault,
                              width: 60.w,
                              height: 60.w,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName ?? '',
                              style: AppStyles.STYLE_16_BOLD.copyWith(
                                color: AppColors.color0C092A,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              user.email ?? '',
                              style: AppStyles.STYLE_12.copyWith(
                                color: AppColors.color7C8BA0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Share button with dropdown
                      PopupMenuButton<String>(
                        color: AppColors.white,
                        initialValue: user.permissions,
                        onSelected: (String permission) {
                          _shareWithPermission(user.userId ?? '', permission);
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  color: AppColors.color3461FD,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'viewOnly'.tr,
                                  style: AppStyles.STYLE_14.copyWith(
                                    color: AppColors.color0C092A,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColors.color3461FD,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'editAccess'.tr,
                                  style: AppStyles.STYLE_14.copyWith(
                                    color: AppColors.color0C092A,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        offset: Offset(0, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 8,
                        child: Obx(() {
                          final currentPermission =
                              controller.permissionChanges[user.userId] ??
                                  user.permissions;
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.color3461FD,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  currentPermission == 'edit'
                                      ? Icons.edit
                                      : Icons.visibility,
                                  color: AppColors.white,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  currentPermission == 'edit'
                                      ? 'editAccess'.tr
                                      : 'viewOnly'.tr,
                                  style: AppStyles.STYLE_12.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.white,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

// Helper method để share với permission
  void _shareWithPermission(String userId, String permission) {
    controller.shareItinerary(userId, permission);
    Get.back(); // Close the bottom sheet
  }

  void _showSharedUsersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.colorF5F9FE,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sharedUsers'.tr,
                    style: AppStyles.STYLE_20_BOLD.copyWith(
                      color: AppColors.color0C092A,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clearPermissionChanges();
                      Get.back();
                    },
                    child: Text(
                      'close'.tr,
                      style: AppStyles.STYLE_16.copyWith(
                        color: AppColors.color3461FD,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Shared users list
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: controller.sharedUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.sharedUsers[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.colorF5F9FE),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.r),
                              child: Image.network(
                                user.profilePicture ??
                                    AppImages.imageUserDefault,
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.imageUserDefault,
                                    width: 60.w,
                                    height: 60.w,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName ?? '',
                                    style: AppStyles.STYLE_16_BOLD.copyWith(
                                      color: AppColors.color0C092A,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    user.email ?? '',
                                    style: AppStyles.STYLE_12.copyWith(
                                      color: AppColors.color7C8BA0,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: AppColors.white,
                              initialValue: user.permissions,
                              onSelected: (String permission) {
                                controller.updateUserPermission(
                                    user.userId!, permission);
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        color: (controller.permissionChanges[
                                                        user.userId] ??
                                                    user.permissions) ==
                                                'view'
                                            ? AppColors.color3461FD
                                            : AppColors.color7C8BA0,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'viewOnly'.tr,
                                        style: AppStyles.STYLE_14.copyWith(
                                          color: (controller.permissionChanges[
                                                          user.userId] ??
                                                      user.permissions) ==
                                                  'view'
                                              ? AppColors.color3461FD
                                              : AppColors.color0C092A,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: (controller.permissionChanges[
                                                        user.userId] ??
                                                    user.permissions) ==
                                                'edit'
                                            ? AppColors.color3461FD
                                            : AppColors.color7C8BA0,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'editAccess'.tr,
                                        style: AppStyles.STYLE_14.copyWith(
                                          color: (controller.permissionChanges[
                                                          user.userId] ??
                                                      user.permissions) ==
                                                  'edit'
                                              ? AppColors.color3461FD
                                              : AppColors.color0C092A,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              offset: Offset(0, 40.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              elevation: 8,
                              child: Obx(() {
                                final currentPermission =
                                    controller.permissionChanges[user.userId] ??
                                        user.permissions;
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.color3461FD,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        currentPermission == 'edit'
                                            ? Icons.edit
                                            : Icons.visibility,
                                        color: AppColors.white,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        currentPermission == 'edit'
                                            ? 'editAccess'.tr
                                            : 'viewOnly'.tr,
                                        style: AppStyles.STYLE_12.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: AppColors.white,
                                        size: 16.sp,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
            // Save changes button
            Obx(() => controller.permissionChanges.isNotEmpty
                ? Column(
                    children: [
                      AppButton(
                        onPressed: () {
                          controller.updateSharedUserPermissions();
                        },
                        text: 'saveChanges'.tr,
                        textStyle: AppStyles.STYLE_12.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        width: 150.w,
                        height: 50.h,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  )
                : const SizedBox()),
          ],
        ),
      ),
    ).whenComplete(() {
      controller.clearPermissionChanges();
    });
  }
}
