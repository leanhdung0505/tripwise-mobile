import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/ui/plan/search_places/controller/search_places_controller.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/common/base/widgets/app_text_field.dart';
import 'package:trip_wise_app/data/model/itinerary/place_model.dart';

import '../../../../common/base/widgets/app_time_picker_modal.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../utils/date_time_utils.dart';

class SearchPlacesPage extends BasePage<SearchPlacesController> {
  const SearchPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorF5F9FE,
      body: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                // Header section with search
                AnimatedContainer(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.only(
                    top: controller.isSearchActive.value ? 20.h : 40.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 20.h,
                  ),
                  child: Column(
                    children: [
                      // Title and location (hide when search is active)
                      if (!controller.isSearchActive.value) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: Get.back,
                              child: Text(
                                'done'.tr,
                                style: AppStyles.STYLE_14.copyWith(
                                  color: AppColors.color3461FD,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'daNangVietnam'.tr,
                                        style: AppStyles.STYLE_16_BOLD.copyWith(
                                          color: AppColors.color0C092A,
                                          fontSize: 24.sp,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '${DateTimeUtils.tryParse(controller.startDate)!.formatDate()} - ${DateTimeUtils.tryParse(controller.endDate)!.formatDate()}',
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
                        ),
                        SizedBox(height: 24.h),
                      ],

                      // Search bar with animation
                      Row(
                        children: [
                          Expanded(
                            child: AppTextFiled(
                              controller: controller.searchController,
                              prefixIcon: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SvgPicture.asset(
                                  AppImages.icSearch,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                              ),
                              fillColor: AppColors.white,
                              focusedBorderColor: AppColors.transparent,
                              onTap: controller.activateSearch,
                              onChanged: controller.onSearchChanged,
                              height: 48.h,
                            ),
                          ),
                          if (controller.isSearchActive.value)
                            TextButton(
                              onPressed: controller.deactivateSearch,
                              child: Text(
                                'cancel'.tr,
                                style: AppStyles.STYLE_14.copyWith(
                                  color: AppColors.color3461FD,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content section
                Expanded(
                  child: controller.isSearchActive.value
                      ? _buildSearchResults()
                      : _buildExploreAttractions(),
                ),
              ],
            ),
          )),
    );
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
          : Obx(
              () => ListView.builder(
                padding: EdgeInsets.all(16.w),
                controller: controller.scrollSearchController,
                itemCount: controller.searchResults.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.searchResults.length) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppColors.color3461FD,
                      ),
                    );
                  }

                  final place = controller.searchResults[index];
                  return InkWell(
                    onTap: () {
                      controller.navigateToPlaceDetails(place);
                    },
                    child: Container(
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
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              _getValidPhotoUrl(place),
                              width: 60.w,
                              height: 60.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // If the current image fails, try the next one
                                return Image.network(
                                  _getValidPhotoUrl(place, skipFirst: true),
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // If the second image fails, try the last one
                                    return Image.network(
                                      _getValidPhotoUrl(place,
                                          skipFirst: true, skipSecond: true),
                                      width: 60.w,
                                      height: 60.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // If all photos fail, show placeholder
                                        return Image.network(
                                          'https://via.placeholder.com/60',
                                          width: 60.w,
                                          height: 60.w,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  },
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
                                  place.name ?? '',
                                  style: AppStyles.STYLE_16_BOLD.copyWith(
                                    color: AppColors.color0C092A,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  place.address ?? '',
                                  style: AppStyles.STYLE_12.copyWith(
                                    color: AppColors.color7C8BA0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildExploreAttractions() {
    return Container(
      padding: EdgeInsets.only(bottom: 30.h),
      child: Column(
        children: [
          // Page indicator dot
          Expanded(
            child: controller.places.isEmpty
                ? const SizedBox()
                : Obx(
                    () => Stack(
                      children: [
                        CarouselSlider.builder(
                          carouselController: controller.carouselController,
                          itemCount: controller.places.length +
                              (controller.isLoadingMore.value ? 1 : 0),
                          options: CarouselOptions(
                            height: double.infinity,
                            viewportFraction: 0.75,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.15,
                            onPageChanged: (index, reason) {
                              controller.onPageChanged(index);
                            },
                            initialPage: controller.currentPageIndex.value,
                            padEnds: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          itemBuilder: (context, index, realIdx) {
                            if (index == controller.places.length) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 15.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(18.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.color3461FD,
                                  ),
                                ),
                              );
                            }

                            final place = controller.places[index];
                            final bool isSelected =
                                controller.currentPageIndex.value == index;

                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 900),
                              opacity: controller.isLoadingMore.value &&
                                      index == controller.places.length - 1
                                  ? 0.0
                                  : 1.0,
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectAttraction(index);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 900),
                                  curve: Curves.ease,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: isSelected ? 5.h : 15.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(18.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.black.withOpacity(0.08),
                                        blurRadius: isSelected ? 12 : 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image
                                      Expanded(
                                        flex: 12,
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(18.r),
                                              topRight: Radius.circular(18.r),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18.r),
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: Stack(
                                                    children: [
                                                      PageView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: place.photos
                                                                ?.length ??
                                                            1,
                                                        key: PageStorageKey(
                                                            'place_${place.placeId}'),
                                                        controller:
                                                            PageController(
                                                          keepPage: true,
                                                          viewportFraction: 1,
                                                        ),
                                                        itemBuilder: (context,
                                                            photoIndex) {
                                                          return Stack(
                                                            children: [
                                                              Image.network(
                                                                place
                                                                        .photos?[
                                                                            photoIndex]
                                                                        .photoUrl ??
                                                                    place
                                                                        .image ??
                                                                    'https://via.placeholder.com/300x200',
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return Container(
                                                                    color: AppColors
                                                                        .colorF5F9FE,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                        color: AppColors
                                                                            .color3461FD,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Container(
                                                                    color: AppColors
                                                                        .colorF5F9FE,
                                                                    child: Icon(
                                                                      Icons
                                                                          .image,
                                                                      color: AppColors
                                                                          .color7C8BA0,
                                                                      size:
                                                                          40.w,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                    colors: [
                                                                      AppColors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.2),
                                                                      AppColors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ],
                                                                    stops: const [
                                                                      0.5,
                                                                      1.0
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      // Vertical dots for images
                                                      if ((place.photos
                                                                  ?.length ??
                                                              0) >
                                                          1)
                                                        Positioned(
                                                          right: 16.w,
                                                          top: 0,
                                                          bottom: 0,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children:
                                                                  List.generate(
                                                                place.photos
                                                                        ?.length ??
                                                                    0,
                                                                (index) =>
                                                                    Container(
                                                                  width: 6.w,
                                                                  height: 6.w,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    vertical:
                                                                        3.h,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: AppColors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 10.h,
                                                  right: 10.w,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(10.h),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColors
                                                          .color7C8BA0
                                                          .withOpacity(0.7),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller
                                                            .navigateToMap(
                                                                place);
                                                      },
                                                      child: SvgPicture.asset(
                                                        AppImages.icMap,
                                                        width: 24.w,
                                                        height: 24.h,
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 12.h,
                                                  left: 12.w,
                                                  child: SizedBox(
                                                    width: 220.w,
                                                    child: Text(
                                                      Get.locale ==
                                                              const Locale('vi')
                                                          ? place.localName ??
                                                              'Nhà hàng'
                                                          : place.name ??
                                                              'Restaurant',
                                                      style: AppStyles
                                                          .STYLE_16_BOLD
                                                          .copyWith(
                                                        color: AppColors.white,
                                                        fontSize: 18.sp,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Content
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.all(16.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  controller
                                                      .navigateToPlaceDetails(
                                                          place);
                                                },
                                                child: Container(
                                                  width: 200.w,
                                                  height: 50.h,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.color0C092A
                                                        .withOpacity(0.05),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'moreDetails'.tr,
                                                      style: AppStyles.STYLE_14
                                                          .copyWith(
                                                        color: AppColors
                                                            .color0C092A,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              InkWell(
                                                onTap: () async {
                                                  final selectedTime =
                                                      await AppTimePickerModal
                                                          .show(
                                                    context: context,
                                                    title: 'selectTime'.tr,
                                                    initialTime: DateTime.now(),
                                                  );
                                                  controller
                                                      .addActivityToItinerary(
                                                          place, selectedTime!);
                                                },
                                                child: Container(
                                                  width: 45.w,
                                                  height: 45.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        AppColors.color3461FD,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: AppColors.white,
                                                    size: 26.w,
                                                  ),
                                                ),
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
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _getValidPhotoUrl(PlaceModel place,
      {bool skipFirst = false, bool skipSecond = false}) {
    if (skipFirst) {
      if (skipSecond) {
        return place.photos?.last.photoUrl ??
            place.image ??
            'https://via.placeholder.com/60';
      } else {
        return place.photos?[1].photoUrl ??
            place.image ??
            'https://via.placeholder.com/60';
      }
    } else {
      return place.photos?.first.photoUrl ??
          place.image ??
          'https://via.placeholder.com/60';
    }
  }
}
