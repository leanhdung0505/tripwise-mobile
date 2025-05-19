import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/base/widgets/app_divider.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';

class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    this.onDateChanged,
    this.initialDate,
  });

  final Function(DateTime)? onDateChanged;
  final DateTime? initialDate;

  @override
  State<AppDatePicker> createState() => AppDatePickerState();
}

class AppDatePickerState extends State<AppDatePicker> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.initialDate ?? DateTime.now();
    selectedDay = initialDate.day;
    selectedMonth = initialDate.month;
    selectedYear = initialDate.year;
  }

  DateTime getSelectedDate() {
    // Đảm bảo ngày hợp lệ
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final validDay = selectedDay > daysInMonth ? daysInMonth : selectedDay;

    return DateTime(selectedYear, selectedMonth, validDay);
  }

  void _updateDate() {
    widget.onDateChanged?.call(getSelectedDate());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          // Day picker
          Expanded(
            child: _buildPicker(
              items: List.generate(
                  31, (index) => (index + 1).toString().padLeft(2, '0')),
              initialItem: selectedDay - 1,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedDay = index + 1;
                  _updateDate();
                });
              },
            ),
          ),

          // Separator
          Text(
            "/",
            style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.black),
          ),

          // Month picker
          Expanded(
            child: _buildPicker(
              items: List.generate(
                  12, (index) => (index + 1).toString().padLeft(2, '0')),
              initialItem: selectedMonth - 1,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMonth = index + 1;
                  _updateDate();
                });
              },
            ),
          ),

          // Separator
          Text(
            "/",
            style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColors.black),
          ),

          // Year picker
          Expanded(
            child: _buildPicker(
              items: List.generate(100,
                  (index) => (DateTime.now().year - 50 + index).toString()),
              initialItem: selectedYear - (DateTime.now().year - 50),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedYear = DateTime.now().year - 50 + index;
                  _updateDate();
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
