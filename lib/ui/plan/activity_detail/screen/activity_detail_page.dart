import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/ui/plan/activity_detail/controller/activity_detail_controller.dart';

import '../../../../common/base/widgets/app_time_picker_modal.dart';

class ActivityDetailPage extends BasePage<ActivityDetailController> {
  const ActivityDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.place.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: _buildContent(context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400.h,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: AppColors.white,
      elevation: 0,
      forceElevated: true,
      toolbarHeight: 80.h,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 20.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
        ),
      ),
      leadingWidth: 60.w,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: controller.onNavigateBack,
          icon: SvgPicture.asset(
            AppImages.icArrowLeft,
            height: 24.h,
            width: 24.w,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: controller.navigateToMap,
            icon: SvgPicture.asset(
              AppImages.icMap,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() {
          if (controller.images.isEmpty) {
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[500],
                  size: 50.sp,
                ),
              ),
            );
          }

          return Stack(
            children: [
              PageView.builder(
                itemCount: controller.images.length,
                onPageChanged: controller.updateCurrentImageIndex,
                itemBuilder: (context, index) {
                  return Image.network(
                    controller.images[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[500],
                            size: 50.sp,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Image indicators
              if (controller.images.length > 1)
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.images.length,
                      (index) => Obx(() => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: controller.currentImageIndex.value == index
                                ? 20.w
                                : 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: controller.currentImageIndex.value == index
                                  ? AppColors.white
                                  : AppColors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          )),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaceInfo(context),
          SizedBox(height: 20.h),
          _buildRatingSection(),
          SizedBox(height: 20.h),
          _buildContactInfo(),
          SizedBox(height: 20.h),
          _buildDescription(),
          SizedBox(height: 20.h),
          _buildPlaceDetails(),
          SizedBox(height: 20.h),
          _buildWebsiteButton(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildPlaceInfo(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300.w,
                child: Text(
                  controller.placeName,
                  style: AppStyles.STYLE_20_BOLD.copyWith(
                    color: AppColors.color0C092A,
                    fontSize: 24.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              controller.dayNumber == -1
                  ? InkWell(
                      onTap: () async {
                        final selectedTime = await AppTimePickerModal.show(
                          context: context,
                          title: 'selectTime'.tr,
                          initialTime: DateTime.now(),
                        );
                        controller.addActivityToItinerary(
                            controller.place.value!, selectedTime!);
                      },
                      child: Container(
                        width: 45.w,
                        height: 45.w,
                        decoration: const BoxDecoration(
                          color: AppColors.color3461FD,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 26.w,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.color3461FD,
                size: 25.sp,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  controller.place.value?.address ?? '',
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color7C8BA0,
                  ),
                ),
              ),
            ],
          ),
          if (controller.place.value?.priceRange != null &&
              controller.place.value!.priceRange!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: AppColors.color3461FD,
                  size: 25.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  controller.place.value!.priceRange!,
                  style: AppStyles.STYLE_14.copyWith(
                      color: AppColors.color0C092A,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Obx(
      () => Row(
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < controller.rating.floor()
                    ? Colors.amber
                    : Colors.grey[300],
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            controller.rating.toString(),
            style: AppStyles.STYLE_16_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
          SizedBox(width: 20.w),
          Text(
            'reviews'.trParams(
              {
                "review": controller.reviewCount.toString(),
              },
            ),
            style: AppStyles.STYLE_14.copyWith(
              color: AppColors.color7C8BA0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Obx(() {
      final place = controller.place.value;
      if (place == null) return const SizedBox.shrink();

      final hasContactInfo = (place.phone != null && place.phone!.isNotEmpty) ||
          (place.email != null && place.email!.isNotEmpty);

      if (!hasContactInfo) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'contactInformation'.tr,
            style: AppStyles.STYLE_18_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
          SizedBox(height: 12.h),
          if (place.phone != null && place.phone!.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: AppColors.color3461FD,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  place.phone!,
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color7C8BA0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
          if (place.email != null && place.email!.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: AppColors.color3461FD,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  place.email!,
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color7C8BA0,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }

  Widget _buildDescription() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'about'.tr,
            style: AppStyles.STYLE_18_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            controller.placeDescription,
            style: AppStyles.STYLE_14.copyWith(
              color: AppColors.color7C8BA0,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceDetails() {
    return Obx(() {
      final place = controller.place.value;
      if (place == null) return const SizedBox.shrink();

      if (place.isRestaurant && place.restaurantDetail != null) {
        return _buildRestaurantDetails(place.restaurantDetail!);
      }

      if (place.isAttraction && place.attractionDetail != null) {
        return _buildAttractionDetails(place.attractionDetail!);
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildRestaurantDetails(restaurantDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'restaurantDetails'.tr,
          style: AppStyles.STYLE_18_BOLD.copyWith(
            color: AppColors.color0C092A,
          ),
        ),
        SizedBox(height: 12.h),
        if (restaurantDetail.mealTypesString.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.restaurant_menu,
                color: AppColors.color3461FD,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'mealTypes'.tr,
                      style: AppStyles.STYLE_14.copyWith(
                          color: AppColors.color0C092A,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      restaurantDetail.mealTypesString,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color7C8BA0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAttractionDetails(attractionDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'attractionDetails'.tr,
          style: AppStyles.STYLE_18_BOLD.copyWith(
            color: AppColors.color0C092A,
          ),
        ),
        SizedBox(height: 12.h),
        if (attractionDetail.subcategoriesString.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.category,
                color: AppColors.color3461FD,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'categories'.tr,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color0C092A,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      attractionDetail.subcategoriesString,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color7C8BA0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
        if (attractionDetail.subtypesString.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.local_attraction,
                color: AppColors.color3461FD,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'types'.tr,
                      style: AppStyles.STYLE_14.copyWith(
                          color: AppColors.color0C092A,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      attractionDetail.subtypesString,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color7C8BA0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildWebsiteButton() {
    return Obx(() {
      final place = controller.place.value;
      final hasWebsite = place?.website != null && place!.website!.isNotEmpty;
      final hasWebUrl = place?.webUrl != null && place!.webUrl!.isNotEmpty;

      if (!hasWebsite && !hasWebUrl) return const SizedBox.shrink();

      return SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: controller.openWebsite,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.white,
            side: BorderSide(color: AppColors.color3461FD, width: 1.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.public,
                color: AppColors.color3461FD,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'viewMoreOnWebsite'.tr,
                style: AppStyles.STYLE_16_BOLD.copyWith(
                  color: AppColors.color3461FD,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
