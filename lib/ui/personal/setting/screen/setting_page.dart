import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/common/base/storage/local_data.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/custom_app_bar.dart';
import '../../../../resource/asset/app_images.dart';
import '../controller/setting_controller.dart';

class SettingPage extends BasePage<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalData.shared.user;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'setting'.tr,
        showLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                // Profile Section
                Row(
                  children: [
                    SizedBox(
                      width: 110.w,
                      height: 110.h,
                      child: CircleAvatar(
                        backgroundImage: (user?.profilePicture != null)
                            ? NetworkImage(user!.profilePicture!)
                            : const AssetImage(AppImages.imageUserDefault)
                                as ImageProvider,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? '',
                            style: AppStyles.STYLE_18_BOLD.copyWith(
                              color: AppColors.color3B4054,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user?.username ?? '',
                            style: AppStyles.STYLE_14.copyWith(
                              color: AppColors.color7C8BA0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Menu Items
                SizedBox(
                  height: 500.h,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        path: AppImages.icProfileCircle,
                        title: 'myAccount'.tr,
                        onTap: () {
                          Get.toNamed(PageName.profilePage);
                        },
                      ),
                      _buildMenuItem(
                        path: AppImages.icTranslate,
                        title: 'language'.tr,
                        onTap: () => _showLanguageBottomSheet(context),
                      ),
                      _buildMenuItem(
                        path: AppImages.icKey,
                        title: 'changePassword'.tr,
                        onTap: () => Get.toNamed(PageName.changePasswordPage),
                      ),
                      const Spacer(),
                      AppButton(
                        text: 'logout'.tr,
                        textColor: AppColors.white,
                        onPressed: () => controller.onLogout(),
                        bgColor: AppColors.errorColor,
                        height: 55.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String path,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  path,
                  color: textColor,
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.STYLE_16.copyWith(
                      color: textColor ?? AppColors.color3B4054,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.color7C8BA0,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.color7C8BA0.withOpacity(0.2),
      height: 1.h,
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'language'.tr,
              style: AppStyles.STYLE_20.copyWith(
                color: AppColors.color3B4054,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _buildLanguageOption(
              context,
              'English',
              'en',
              Get.locale?.languageCode == 'en',
            ),
            _buildLanguageOption(
              context,
              'Tiếng Việt',
              'vi',
              Get.locale?.languageCode == 'vi',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String languageCode,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        controller.changeLanguage(languageCode);
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppStyles.STYLE_16.copyWith(
                  color: AppColors.color3B4054,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.color3461FD,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}
