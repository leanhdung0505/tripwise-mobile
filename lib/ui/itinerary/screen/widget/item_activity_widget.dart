import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';

class ItemActivityWidget extends StatefulWidget {
  const ItemActivityWidget({super.key});

  @override
  State<ItemActivityWidget> createState() => _ItemActivityWidgetState();
}

class _ItemActivityWidgetState extends State<ItemActivityWidget> {
  final List<String> images = [
    'https://picsum.photos/400/300',
    'https://picsum.photos/400/301',
    'https://picsum.photos/400/302',
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with time and more options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time with icon
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.icClock,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '7:00',
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColors.color0C092A,
                      ),
                    ),
                  ],
                ),
                // More options icon
                SvgPicture.asset(
                  AppImages.icMenu,
                ),
              ],
            ),
          ),

          // Image slider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) => Image.network(
                        images[index],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Indicator
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentIndex == index ? 16 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? AppColors.color3461FD
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Location name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 20.h),
            child: Text(
              'Da Nang Beach',
              style: AppStyles.STYLE_16_BOLD.copyWith(
                color: AppColors.color0C092A,
              ),
            ),
          ),

          // Ratings
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h).copyWith(
              bottom: 10.h,
            ),
            child: Row(
              children: [
                // Star ratings
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Reviews count
                Text(
                  '11,893 reviews',
                  style: AppStyles.STYLE_12.copyWith(
                    color: AppColors.color0C092A,
                  ),
                ),
                const Spacer(),
                // Button for more details
                SvgPicture.asset(
                  AppImages.icMapOutline,
                  height: 35.h,
                  width: 35.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
