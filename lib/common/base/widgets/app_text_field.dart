import 'package:flutter/material.dart';

import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';
import '../../../utils/extension_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFiled extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final String? labelText;
  final String? labelTextOptional;
  final TextStyle? labelStyle;
  final bool? isRequired;
  final ValueChanged<String>? onChanged;
  final bool? isReadOnly;
  final Function()? onTap;
  final double? height; // New parameter for text field height
  final Color? focusedBorderColor;

  const AppTextFiled({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.validator,
    this.fillColor,
    this.labelText,
    this.labelTextOptional,
    this.labelStyle,
    this.isRequired,
    this.onChanged,
    this.onTap,
    this.isReadOnly,
    this.height, // Added to constructor
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null && labelText!.isNotEmpty)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: labelText.nullToEmpty,
                  style: labelStyle ??
                      AppStyles.STYLE_14.copyWith(
                          color: AppColors.color7C8BA0,
                          fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text:
                      isRequired == false ? labelTextOptional.nullToEmpty : '*',
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color7C8BA0,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          onTap: onTap,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          onChanged: onChanged,
          cursorColor: AppColors.color262626,
          style: AppStyles.STYLE_14.copyWith(color: AppColors.color262626),
          readOnly: isReadOnly ?? false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                AppStyles.STYLE_14.copyWith(color: AppColors.color7C8BA0),
            errorText: errorText,
            errorStyle:
                AppStyles.STYLE_12.copyWith(color: AppColors.errorColor),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            // Here's the important part - set consistent padding
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                    vertical: height != null ? height! / 2 - 10 : 15,
                    horizontal: 12),
            enabledBorder: _buildOutlineInputBorder(AppColors.transparent),
            focusedBorder: _buildOutlineInputBorder(
                focusedBorderColor ?? AppColors.color3461FD),
            errorBorder: _buildOutlineInputBorder(AppColors.errorColor),
            focusedErrorBorder: _buildOutlineInputBorder(AppColors.errorColor),
            fillColor: fillColor ?? AppColors.colorF5F9FE,
            filled: true,
            constraints: BoxConstraints(minHeight: height ?? 48.h),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.5.h),
      borderRadius: BorderRadius.circular(12.h),
    );
  }
}
