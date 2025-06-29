import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trip_wise_app/utils/date_time_utils.dart';
import '../../../../../common/base/widgets/custom_bottom_sheet.dart';
import '../../../../../common/base/widgets/app_time_picker_modal.dart';
import '../../../../../data/model/itinerary/activity_model.dart';
import '../../../../../resource/asset/app_images.dart';
import '../../../../../resource/theme/app_colors.dart';
import '../../../../../resource/theme/app_style.dart';
import '../../../../../routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../controller/itinerary_controller.dart';

class ItemActivityWidget extends StatefulWidget {
  final ActivityModel? activity;
  final int? dayNumber;
  final int? activityIndex;

  const ItemActivityWidget(
      {super.key,
      required this.activity,
      required this.dayNumber,
      required this.activityIndex});

  @override
  State<ItemActivityWidget> createState() => _ItemActivityWidgetState();
}

class _ItemActivityWidgetState extends State<ItemActivityWidget> {
  int _currentIndex = 0;
  final ItineraryController itineraryController = Get.find();
  @override
  Widget build(BuildContext context) {
    final List<String> images = widget.activity?.place?.photos
            ?.map((photo) => photo.photoUrl ?? '')
            .toList() ??
        [
          'https://picsum.photos/400/300',
          'https://picsum.photos/400/301',
          'https://picsum.photos/400/302',
        ];

    final String time = widget.activity?.formattedStartTime ?? '7:00 AM';

    final String placeName = Get.locale?.languageCode == 'vi'
        ? (widget.activity?.place?.localName ?? "Biển Đà Nẵng")
        : (widget.activity?.place?.name ?? 'Da Nang Beach');

    final double rating = widget.activity?.place?.rating ?? 4.5;

    final int numberReview = widget.activity?.place?.numberReview ?? 0;

    return GestureDetector(
      onTap: () => _navigateToActivityDetail(),
      child: Container(
        width: 300.w,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icClock,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        time,
                        style: AppStyles.STYLE_14.copyWith(
                          color: AppColors.color0C092A,
                        ),
                      ),
                    ],
                  ),
                  // More options icon
                  InkWell(
                    child: SvgPicture.asset(
                      AppImages.icMenu,
                    ),
                    onTap: () => _showItineraryMenu(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) => Image.network(
                          images[index],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppColors.color3461FD,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Indicator
                    Positioned(
                      bottom: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentIndex == index ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? AppColors.color3461FD
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 20.h),
              child: Text(
                placeName,
                style: AppStyles.STYLE_16_BOLD.copyWith(
                  color: AppColors.color0C092A,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h).copyWith(
                bottom: 10.h,
              ),
              child: Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < rating.floor()
                            ? Colors.amber
                            : Colors.grey[300],
                        size: 10,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'reviews'.trParams(
                      {
                        "review": numberReview.toString(),
                      },
                    ),
                    style: AppStyles.STYLE_12.copyWith(
                      color: AppColors.color0C092A,
                    ),
                  ),
                  const Spacer(),
                  // Button for map location
                  InkWell(
                    onTap: _navigateToMap,
                    child: SvgPicture.asset(
                      AppImages.icMapOutline,
                      height: 35.h,
                      width: 35.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToActivityDetail() {
    if (widget.activity?.place != null) {
      Get.toNamed(
        PageName.activityDetailPage,
        arguments: {
          'place': widget.activity?.place,
          'dayNumber': widget.dayNumber,
          'itineraryId': itineraryController.itineraryId,
          'dayId': itineraryController
              .days[itineraryController.selectedDayIndex.value].dayId,
        },
      );
    }
  }

  void _navigateToMap() async {
    if (widget.activity?.place == null) return;

    try {
      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition();

      Get.toNamed(
        PageName.mapPage,
        arguments: {
          'showRoute': true,
          'startLat': position.latitude,
          'startLng': position.longitude,
          'endLat': widget.activity!.place!.latitude,
          'endLng': widget.activity!.place!.longitude,
          'activities': [widget.activity],
          'activityIndex': widget.activityIndex,
          'showCurrentLocation': true,
          'dayNumber': widget.dayNumber,
        },
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Fallback to just showing the location without route
      Get.toNamed(
        PageName.mapPage,
        arguments: {
          'activities': [widget.activity],
          'dayNumber': widget.dayNumber,
        },
      );
    }
  }

  void _showItineraryMenu(BuildContext context) {
    final menuOptions = [
      MenuOption(
        title: 'changeTimeDayActivity'.tr,
        iconPath: AppImages.icClock,
        iconColor: AppColors.color0C092A,
        onTap: () async {
          DateTime? initialTime;
          try {
            if (widget.activity?.startTime != null) {
              initialTime = DateTime.tryParse(widget.activity!.startTime!);
            }
          } catch (e) {
            debugPrint('Error parsing time: $e');
          }

          final selectedTime = await AppTimePickerModal.show(
            context: context,
            title: 'selectTime'.tr,
            initialTime: initialTime ?? DateTime.now(),
          );
          // ignore: use_build_context_synchronously
          _showChangeTimeConfirmation(context, selectedTime!);
        },
      ),
      MenuOption(
        title: 'detail'.tr,
        iconPath: AppImages.icMoreCircle,
        onTap: () {
          _navigateToActivityDetail();
        },
      ),
      MenuOption(
        title: 'deleteActivity'.tr,
        iconPath: AppImages.icDelete,
        titleColor: AppColors.errorColor,
        iconColor: AppColors.errorColor,
        onTap: () {
          _showDeleteConfirmation(context);
        },
      ),
    ];
    context.showMenuBottomSheet(
      options: menuOptions,
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
      btnOkOnPress: () => itineraryController
          .deleteActivity(widget.activity!.itineraryActivityId!),
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
            'confirmDeleteActivity'.tr,
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

  void _showChangeTimeConfirmation(
      BuildContext context, DateTime? selectedTime) {
    final String newTime = selectedTime!.formatTime().toString();
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      dialogBackgroundColor: AppColors.white,
      btnCancelOnPress: () {},
      btnOkText: 'changeTime'.tr,
      btnCancelText: 'cancel'.tr,
      btnCancelColor: AppColors.color7C8BA0,
      btnOkColor: AppColors.color3461FD,
      btnOkOnPress: () => itineraryController.changeTimeActivity(
        widget.activity!.itineraryActivityId!,
        newTime,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'confirmChange'.tr,
            style: AppStyles.STYLE_20.copyWith(
              color: AppColors.color3461FD,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'confirmChangeTime'.tr,
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
