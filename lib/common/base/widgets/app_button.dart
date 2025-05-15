import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';

class AppButton extends StatelessWidget {
  AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.height,
    this.width,
    this.unEnabled = false,
    this.isLoading = false,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    this.boderColor = AppColors.transparent,
    this.bgColor = AppColors.color3461FD,
    this.textColor = AppColors.white,
    Color? enabledColor,
    this.elevation = 5.0,
    Gradient? gradient,
  })  : textStyle = textStyle ?? AppStyles.STYLE_16_BOLD,
        borderRadius = borderRadius ?? BorderRadius.circular(8.r),
        padding =
            padding ?? EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
        enabledColor = enabledColor ?? AppColors.color3461FD.withOpacity(0.4),
        gradient = gradient ??
            LinearGradient(
              colors: [bgColor, bgColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            );

  final String? text;
  final Color bgColor;
  final Color textColor;
  final Color boderColor;
  final double? height;
  final double? width;
  final VoidCallback? onPressed;
  final bool unEnabled;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final Color enabledColor;
  final double elevation;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: unEnabled || isLoading ? 0 : elevation,
      borderRadius: borderRadius,
      color: Colors.transparent,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: !unEnabled && !isLoading ? gradient : null,
          color: unEnabled || isLoading ? enabledColor : null,
          border: Border.all(
            color: boderColor,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: unEnabled || isLoading ? null : onPressed,
          splashColor: bgColor.withOpacity(0.1),
          child: Container(
            padding: padding,
            alignment: Alignment.center,
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: CircularProgressIndicator(
                          color: textColor,
                          strokeWidth: 2.0,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'loading'.tr,
                        style: textStyle.copyWith(color: textColor),
                      ),
                    ],
                  )
                : Text(
                    text ?? "",
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                      color:
                          unEnabled ? textColor.withOpacity(0.4) : textColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}