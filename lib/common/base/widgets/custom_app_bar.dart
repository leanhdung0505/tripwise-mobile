import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resource/theme/app_style.dart';
import '../../../utils/extension_utils.dart';
import '../../../resource/asset/app_images.dart';
import '../../../resource/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.leading,
      this.title,
      this.actions,
      this.showShadow = true,
      this.backgroundColor,
      this.toolbarHeight,
      this.showLeading = true,
      this.fillColor,
      this.transparentBackground = false,
      this.onTap});

  final Widget? leading;
  final String? title;
  final List<Widget>? actions;
  final bool showShadow;
  final Color? backgroundColor;
  final double? toolbarHeight;
  final bool showLeading;
  final Color? fillColor;
  final bool transparentBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                )
              ]
            : [],
      ),
      child: AppBar(
        backgroundColor: transparentBackground
            ? Colors.transparent
            : fillColor ?? AppColors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: showLeading
            ? InkWell(
                onTap: onTap ?? Get.back,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    width: 24.h,
                    height: 24.h,
                    AppImages.icArrowLeft,
                  ),
                ),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(
          title.nullToEmpty,
          style: AppStyles.STYLE_20_BOLD.copyWith(
            color: AppColors.color262626,
            fontSize: 22.sp,
          ),
        ),
        actions: actions,
        toolbarHeight: toolbarHeight ?? kToolbarHeight,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
