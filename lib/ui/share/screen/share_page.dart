import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import '../../../common/base/storage/local_data.dart';
import '../../../common/base/widgets/app_button.dart';
import '../../../data/model/itinerary/itinerary_model.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';
import '../../../utils/date_time_utils.dart';
import '../controller/share_controller.dart';

class SharePage extends BasePage<ShareController> {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorF5F9FE,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TRIPWISE',
                    style: AppStyles.STYLE_20_BOLD.copyWith(
                      color: AppColors.color3461FD,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshItineraryList,
                  color: AppColors.color3461FD,
                  backgroundColor: AppColors.white,
                  strokeWidth: 2.5,
                  child: Obx(
                    () {
                      if (controller.isLoading.value &&
                          controller.itineraryList.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.itineraryList.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.travel_explore_outlined,
                                      size: 64.sp,
                                      color: AppColors.color7C8BA0
                                          .withOpacity(0.5),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'noTripsYet'.tr,
                                      style: AppStyles.STYLE_16_BOLD.copyWith(
                                        color: AppColors.color7C8BA0,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'pullToRefresh'.tr,
                                      style: AppStyles.STYLE_14.copyWith(
                                        color: AppColors.color7C8BA0
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.itineraryList.length +
                            (controller.isLoading.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.itineraryList.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.color3461FD,
                              )),
                            );
                          }

                          final trip = controller.itineraryList[index];
                          return index == 0
                              ? _buildFirstTripCard(trip)
                              : _buildTripCard(trip);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstTripCard(ItineraryModel trip) {
    final sharedUsers = trip.sharedUsers ?? [];
    final displayCount = sharedUsers.length > 4 ? 4 : sharedUsers.length;

    return Container(
      height: 350.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.color7C8BA0.withOpacity(0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.color7C8BA0.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            controller.navigateToItineraryDetail(trip);
          },
          child: Stack(
            children: [
              if (trip.hotel?.image != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 250.h,
                  child: Image.network(
                    trip.hotel?.image ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 250.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.black.withOpacity(0.3),
                        AppColors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Date at top left
              Positioned(
                top: 16.h,
                left: 16.w,
                child: Text(
                  '${DateTimeUtils.tryParse(trip.startDate!)?.formatDate()} - ${DateTimeUtils.tryParse(trip.endDate!)?.formatDate()}',
                  style: AppStyles.STYLE_14_BOLD.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              // Destination at top left (below date)
              Positioned(
                top: 50.h,
                left: 16.w,
                right: 60.w,
                child: Text(
                  trip.destinationCity == "Da Nang"
                      ? "daNangVietnam".tr
                      : 'Unknown Destination',
                  style: AppStyles.STYLE_18_BOLD.copyWith(
                    color: AppColors.white,
                    fontSize: 26.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Bottom section with white background
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100.h,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  child: Row(
                    children: [
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        (trip.owner?.profilePicture != null)
                                            ? NetworkImage(
                                                trip.owner!.profilePicture!)
                                            : const AssetImage(
                                                    AppImages.imageUserDefault)
                                                as ImageProvider,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Row(
                                  children: [
                                    if (sharedUsers.isNotEmpty)
                                      SizedBox(
                                        width: displayCount * 15.w + 10.w,
                                        height: 22.h,
                                        child: Stack(
                                          children: List.generate(displayCount,
                                              (index) {
                                            return Positioned(
                                              left: index * 15.w,
                                              child: Container(
                                                height: 24.h,
                                                width: 24.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.white,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  backgroundImage: (sharedUsers[
                                                                  index]
                                                              .profilePicture !=
                                                          null)
                                                      ? NetworkImage(
                                                          sharedUsers[index]
                                                              .profilePicture!)
                                                      : const AssetImage(AppImages
                                                              .imageUserDefault)
                                                          as ImageProvider,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              trip.destinationCity ?? 'Unknown Destination',
                              style: AppStyles.STYLE_16_BOLD.copyWith(
                                color: AppColors.color0C092A,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              DateTimeUtils.tryParse(trip.createdAt!)
                                      ?.formatDate() ??
                                  '',
                              style: AppStyles.STYLE_12.copyWith(
                                color: AppColors.color0C092A.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // "See Your Plan" button
                      AppButton(
                        onPressed: () {
                          controller.navigateToItineraryDetail(trip);
                        },
                        text: 'seeYourPlan'.tr,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(ItineraryModel trip) {
    final sharedUsers = trip.sharedUsers ?? [];
    final displayCount = sharedUsers.length > 4 ? 4 : sharedUsers.length;

    return Container(
      height: 150.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.color7C8BA0.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.color7C8BA0.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            controller.navigateToItineraryDetail(trip);
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(12.r),
                child: trip.hotel?.image != null
                    ? Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: NetworkImage(trip.hotel?.image ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 66.w,
                        height: 66.h,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16.r,
                    bottom: 16.r,
                    right: 16.r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row with avatar and more icon
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: CircleAvatar(
                                  backgroundImage:
                                      (trip.owner?.profilePicture != null)
                                          ? NetworkImage(
                                              trip.owner!.profilePicture!)
                                          : const AssetImage(
                                                  AppImages.imageUserDefault)
                                              as ImageProvider,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              // Stack of shared user avatars
                              if (sharedUsers.isNotEmpty)
                                SizedBox(
                                  width: displayCount * 15.w + 10.w,
                                  height: 24.h,
                                  child: Stack(
                                    children:
                                        List.generate(displayCount, (index) {
                                      return Positioned(
                                        left: index * 15.w,
                                        child: Container(
                                          height: 24.h,
                                          width: 24.w,
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
                                                ? NetworkImage(
                                                    sharedUsers[index]
                                                        .profilePicture!)
                                                : const AssetImage(AppImages
                                                        .imageUserDefault)
                                                    as ImageProvider,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 130.w,
                                    child: Text(
                                      trip.destinationCity == "Da Nang"
                                          ? "daNangVietnam".tr
                                          : 'Unknown Destination',
                                      style: AppStyles.STYLE_16_BOLD.copyWith(
                                        color: AppColors.color0C092A,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    DateTimeUtils.tryParse(trip.startDate!)
                                            ?.formatDate() ??
                                        '',
                                    style: AppStyles.STYLE_14.copyWith(
                                      color: AppColors.color7C8BA0,
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.color7C8BA0.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              color: AppColors.color7C8BA0.withOpacity(0.5),
                              size: 25.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
