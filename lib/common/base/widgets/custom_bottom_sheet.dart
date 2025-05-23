import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Model for menu option
class MenuOption {
  final String title;
  final String iconPath;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback onTap;

  MenuOption({
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.titleColor,
    this.iconColor,
  });
}

class CustomBottomSheetModal {
  static void show({
    required BuildContext context,
    required List<MenuOption> options,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetContent(
        options: options,
        title: title,
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  final List<MenuOption> options;
  final String? title;

  const _BottomSheetContent({
    required this.options,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Title (if provided)
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),
          ],
          
          // Menu options
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: options.length,
            separatorBuilder: (context, index) => SizedBox(height: 4.h),
            itemBuilder: (context, index) {
              final option = options[index];
              return _MenuOptionTile(option: option);
            },
          ),
          
          // Cancel button
          Container(
            margin: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'cancel'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuOptionTile extends StatelessWidget {
  final MenuOption option;

  const _MenuOptionTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        option.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 16.h,
        ),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: SvgPicture.asset(
                option.iconPath,
                colorFilter: option.iconColor != null
                    ? ColorFilter.mode(option.iconColor!, BlendMode.srcIn)
                    : null,
              ),
            ),
            SizedBox(width: 16.w),
            // Title
            Expanded(
              child: Text(
                option.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: option.titleColor ?? Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension for easier usage
extension BottomSheetHelper on BuildContext {
  void showMenuBottomSheet({
    required List<MenuOption> options,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    CustomBottomSheetModal.show(
      context: this,
      options: options,
      title: title,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }
}