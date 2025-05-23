import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';

import '../../../../../resource/asset/app_images.dart';

class ItemDistanceWidget extends StatelessWidget {
  const ItemDistanceWidget({
    super.key,
    required this.distance,
    this.duration = '',
  });
  final String distance;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final String displayDuration = duration.isNotEmpty ? ' • $duration' : '';
    return Container(
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
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "$distance$displayDuration",
                  style:
                      AppStyles.STYLE_12.copyWith(color: AppColors.color0C092A),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Direction",
                  style: AppStyles.STYLE_12.copyWith(
                    color: AppColors.color3461FD,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                SvgPicture.asset(
                  AppImages.icArrowCircleRight,
                  height: 15.h,
                  width: 15.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
