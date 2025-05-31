import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;

import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';
import '../../../utils/enum.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w, bottom: 20.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: MenuItem.values.map((menu) {
          return _buildNavItem(
            iconPath: currentIndex == menu.id ? menu.iconSelectedPath : menu.iconPath,
            label: menu.translatedLabel,
            isSelected: currentIndex == menu.id,
            onTap: () => onItemTapped(menu.id),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
    String? badgeContent,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeContent != null)
            badges.Badge(
              badgeContent: Text(
                badgeContent,
                style: AppStyles.STYLE_10.copyWith(color: AppColors.white),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              child: SvgPicture.asset(
                iconPath,
                height: 24.h,
                width: 24.h,
                colorFilter: ColorFilter.mode(
                    isSelected
                        ? AppColors.color3461FD
                        : AppColors.color7C8BA0,
                    BlendMode.srcIn),
              ),
            )
          else
            SvgPicture.asset(
              iconPath,
              height: 24.h,
              width: 24.h,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? AppColors.color3461FD
                    : AppColors.color7C8BA0,
                BlendMode.srcIn,
              ),
            ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppStyles.STYLE_12.copyWith(
              color: isSelected
                  ? AppColors.color3461FD
                  : AppColors.color7C8BA0,
            ),
          ),
        ],
      ),
    );
  }
}
