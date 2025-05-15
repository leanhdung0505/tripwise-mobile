import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';

class AppPinCode extends StatelessWidget {
  const AppPinCode({
    super.key,
    this.onCompleted,
    this.controller,
    this.focusNode,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final hintStyle = AppStyles.STYLE_14.copyWith(color: AppColors.color3B4054);
    final textStyle = AppStyles.STYLE_20.copyWith(color: AppColors.color3B4054,
        fontWeight: FontWeight.w600,fontSize: 22.sp);

    return PinCodeTextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      mainAxisAlignment: MainAxisAlignment.center,
      appContext: context,
      textStyle: textStyle,
      length: 5,
      cursorColor: AppColors.color3B4054,
      cursorHeight: 25.h,
      cursorWidth: 2.w,
      hintCharacter: "-",
      hintStyle: hintStyle,
      enableActiveFill: true,
      separatorBuilder: (context, index) {
        return SizedBox(width: 16.w);
      },
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: 70.h,
        fieldWidth: 56.w,
        activeFillColor: AppColors.colorF5F9FE,
        inactiveFillColor: AppColors.colorF5F9FE,
        selectedFillColor: AppColors.colorF5F9FE,
        inactiveColor: AppColors.colorF5F9FE,
        activeColor: AppColors.color3461FD,
        selectedColor: AppColors.colorF5F9FE,
      ),
      scrollPadding: EdgeInsets.zero,
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}
