import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/base/widgets/app_date_picker_modal.dart';
import '../../../../../data/model/itinerary/day_model.dart';
import '../../../../../resource/theme/app_colors.dart';
import '../../../../../resource/theme/app_style.dart';
import '../../../../../resource/asset/app_images.dart';
import '../../../../../common/base/widgets/custom_bottom_sheet.dart';
import 'package:get/get.dart';

import '../../controller/itinerary_controller.dart';

class DayTabWidget extends StatelessWidget {
  final DayModel day;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(int)? onDeleteDay;

  const DayTabWidget({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
    this.onDeleteDay,
  });

  void _showDayOptions(BuildContext context) {
    final ItineraryController itineraryController = Get.find();
    final menuOptions = [
      MenuOption(
        title: 'deleteDay'.tr,
        iconPath: AppImages.icDelete,
        titleColor: AppColors.errorColor,
        iconColor: AppColors.errorColor,
        onTap: () {
          if (onDeleteDay != null) {
            onDeleteDay!(day.dayId!);
          }
        },
      ),
      MenuOption(
        title: 'addDay'.tr,
        iconPath: AppImages.icAddCalendar,
        titleColor: AppColors.color0C092A,
        iconColor: AppColors.color0C092A,
        onTap: () async {
          final selectedDate = await AppDatePickerModal.show(
            context: context,
            initialDate: DateTime.now(),
            title: 'selectDay'.tr,
          );
          itineraryController.addDay(selectedDate!);
        },
      ),
    ];

    context.showMenuBottomSheet(
      options: menuOptions,
      title: 'days'.trParams({'day': day.dayNumber.toString()}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDayOptions(context),
      child: Container(
        width: 120.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.color3461FD : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'days'.trParams(
                {
                  "day": day.dayNumber.toString(),
                },
              ),
              style: AppStyles.STYLE_14.copyWith(
                color: isSelected ? AppColors.white : AppColors.color0C092A,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _formatDate(day.date),
              style: AppStyles.STYLE_12.copyWith(
                color: isSelected
                    ? AppColors.white
                    : AppColors.color0C092A.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final DateTime date = DateTime.parse(dateString);
      final String dayName = _getDayName(date.weekday);
      final String dayOfMonth = date.day.toString().padLeft(2, '0');
      return '$dayName $dayOfMonth';
    } catch (e) {
      return '';
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'monday'.tr;
      case 2:
        return 'tuesday'.tr;
      case 3:
        return 'wednesday'.tr;
      case 4:
        return 'thursday'.tr;
      case 5:
        return 'friday'.tr;
      case 6:
        return 'saturday'.tr;
      case 7:
        return 'sunday'.tr;
      default:
        return '';
    }
  }
}
