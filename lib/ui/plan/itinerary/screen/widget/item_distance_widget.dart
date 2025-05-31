import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import '../../../../../data/model/itinerary/activity_model.dart';
import '../../../../../resource/asset/app_images.dart';
import '../../controller/itinerary_controller.dart';

class ItemDistanceWidget extends StatelessWidget {
  final ItineraryController itineraryController = Get.find();

  ItemDistanceWidget({
    super.key,
    required this.distance,
    this.duration = '',
    required this.fromActivity,
    required this.toActivity, 
    required this.activityIndex,
  });

  final String distance;
  final String duration;
  final int activityIndex;
  final ActivityModel fromActivity;
  final ActivityModel toActivity;

  void _onDirectionPressed() {
    final coordinates =
        itineraryController.getCoordinatesBetweenActivities(activityIndex);
    final startLat = coordinates['startLat'];
    final startLng = coordinates['startLng'];
    final endLat = coordinates['endLat'];
    final endLng = coordinates['endLng'];

    if (startLat != null &&
        startLng != null &&
        endLat != null &&
        endLng != null) {
      Get.toNamed(
        PageName.mapPage,
        arguments: {
          'showRoute': true,
          'startLat': startLat,
          'startLng': startLng,
          'endLat': endLat,
          'endLng': endLng,
          'activities': [fromActivity, toActivity],
          'showCurrentLocation': false,
          'activityIndex': activityIndex,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final coordinates =
        itineraryController.getCoordinatesBetweenActivities(activityIndex);
    final hasValidCoordinates = coordinates['startLat'] != null &&
        coordinates['startLng'] != null &&
        coordinates['endLat'] != null &&
        coordinates['endLng'] != null;

    final String displayDuration = duration.isNotEmpty ? ' • $duration' : '';
    return InkWell(
      onTap: hasValidCoordinates ? _onDirectionPressed : null,
      child: Container(
        width: 300.w,
        decoration: BoxDecoration(
          color: AppColors.color3461FD.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icDriving,
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "$distance$displayDuration",
                    style: AppStyles.STYLE_12
                        .copyWith(color: AppColors.color0C092A),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "direction".tr,
                    style: AppStyles.STYLE_12.copyWith(
                      color: hasValidCoordinates
                          ? AppColors.color3461FD
                          : AppColors.color7C8BA0,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  SvgPicture.asset(
                    AppImages.icArrowCircleRight,
                    height: 15.h,
                    width: 15.w,
                    color: hasValidCoordinates
                        ? AppColors.color3461FD
                        : AppColors.color7C8BA0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
