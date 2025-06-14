import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:badges/badges.dart' as badges;

import '../../../resource/theme/app_colors.dart';
import '../../../resource/theme/app_style.dart';
import '../../../utils/enum.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _indicatorController;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();

    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _indicatorAnimation = CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeInOut,
    );

    _indicatorController.forward();
  }

  @override
  void didUpdateWidget(CustomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _indicatorController.reset();
      _indicatorController.forward();
    }
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = MenuItem.values.length;
    final itemWidth = (1.sw - 40.w) / itemCount; // Tính width của mỗi item

    return Container(
      padding: EdgeInsets.only(bottom: 5.h),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator bar
          Container(
            height: 3.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.color7C8BA0.withOpacity(0.2),
              borderRadius: BorderRadius.circular(1.5.h),
            ),
            child: AnimatedBuilder(
              animation: _indicatorAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      left: widget.currentIndex * itemWidth * 1.15,
                      child: Transform.scale(
                        scaleX: _indicatorAnimation.value,
                        child: Container(
                          height: 3.h,
                          width: itemWidth,
                          decoration: BoxDecoration(
                            color: AppColors.color3461FD,
                            borderRadius: BorderRadius.circular(1.5.h),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 12.h),

          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MenuItem.values.map((menu) {
              return _buildNavItem(
                iconPath: widget.currentIndex == menu.id
                    ? menu.iconSelectedPath
                    : menu.iconPath,
                label: menu.translatedLabel,
                isSelected: widget.currentIndex == menu.id,
                onTap: () => widget.onItemTapped(menu.id),
              );
            }).toList(),
          ),
        ],
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
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon với badge (nếu có)
              if (badgeContent != null)
                badges.Badge(
                  badgeContent: Text(
                    badgeContent,
                    style: AppStyles.STYLE_10.copyWith(color: AppColors.white),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  child: _buildIcon(iconPath, isSelected),
                )
              else
                _buildIcon(iconPath, isSelected),

              SizedBox(height: 4.h),

              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppStyles.STYLE_12.copyWith(
                  color: isSelected
                      ? AppColors.color3461FD
                      : AppColors.color7C8BA0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String iconPath, bool isSelected) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: isSelected ? 1.1 : 1.0,
      child: SvgPicture.asset(
        iconPath,
        height: 24.h,
        width: 24.h,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColors.color3461FD : AppColors.color7C8BA0,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
