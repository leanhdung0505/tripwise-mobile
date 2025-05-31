import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';
import '../../../utils/enum.dart';
import 'app_divider.dart';

class AppTimePicker extends StatefulWidget {
  final Function(DateTime)? onTimeSelected;
  final DateTime? initialTime;
  final bool shouldCallbackImmediately;

  const AppTimePicker({
    super.key,
    this.onTimeSelected,
    this.initialTime,
    this.shouldCallbackImmediately = false,
  });

  @override
  State<AppTimePicker> createState() => AppTimePickerState();
}

class AppTimePickerState extends State<AppTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  late TimePeriod selectedPeriod;

  List<String> get periodTexts =>
      Get.locale?.languageCode == 'vi' ? ['Sáng', 'Chiều'] : ['AM', 'PM'];

  @override
  void initState() {
    super.initState();
    final now = widget.initialTime ?? DateTime.now();
    selectedHour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    selectedMinute = now.minute;
    selectedPeriod = now.hour >= 12 ? TimePeriod.PM : TimePeriod.AM;
  }

  DateTime getSelectedTime() {
    final hour = selectedPeriod == TimePeriod.PM && selectedHour != 12
        ? selectedHour + 12
        : (selectedPeriod == TimePeriod.AM && selectedHour == 12
            ? 0
            : selectedHour);

    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      selectedMinute,
    );
  }

  void _updateTime() {
    if (widget.shouldCallbackImmediately) {
      widget.onTimeSelected?.call(getSelectedTime());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Hours
          Expanded(
            child: _buildPicker(
              items: List.generate(
                  12, (index) => (index + 1).toString().padLeft(2, '0')),
              initialItem: selectedHour - 1,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHour = index + 1;
                  _updateTime();
                });
              },
            ),
          ),
          Text(
            ":",
            style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.black),
          ),
          // Minutes
          Expanded(
            child: _buildPicker(
              items: List.generate(
                  60, (index) => index.toString().padLeft(2, '0')),
              initialItem: selectedMinute,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = index;
                  _updateTime();
                });
              },
            ),
          ),
          // AM/PM
          Expanded(
            child: _buildPicker(
              items: periodTexts,
              initialItem: selectedPeriod.index,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedPeriod = TimePeriod.values[index];
                  _updateTime();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required List<String> items,
    required int initialItem,
    required Function(int) onSelectedItemChanged,
  }) {
    return Stack(
      children: [
        CupertinoPicker(
          scrollController:
              FixedExtentScrollController(initialItem: initialItem),
          selectionOverlay: Container(),
          backgroundColor: AppColors.white,
          itemExtent: 40,
          onSelectedItemChanged: onSelectedItemChanged,
          children: items
              .map((item) => Center(
                    child: Text(
                      item,
                      style: AppStyles.STYLE_16.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
        Positioned(
          top: 108.h,
          left: 0,
          right: 0,
          child: AppDivider.dividerWidget(),
        ),
        Positioned(
          top: 142.h,
          left: 0,
          right: 0,
          child: AppDivider.dividerWidget(),
        ),
      ],
    );
  }
}
