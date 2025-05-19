import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';
import 'app_time_picker.dart';

class AppTimePickerModal {
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialTime,
    String? title,
  }) {
    final GlobalKey<AppTimePickerState> timePickerKey =
        GlobalKey<AppTimePickerState>();

    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Title
          if (title != null)
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Text(
                title,
                style: AppStyles.STYLE_16_BOLD.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),

          // Time Picker
          AppTimePicker(
            key: timePickerKey,
            initialTime: initialTime,
            shouldCallbackImmediately: false,
          ),

          // Buttons
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'cancel'.tr,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      final selectedTime =
                          timePickerKey.currentState?.getSelectedTime();
                      Navigator.of(context)
                          .pop(selectedTime ?? initialTime ?? DateTime.now());
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.color3461FD,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'done'.tr,
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
