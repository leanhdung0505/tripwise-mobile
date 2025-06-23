import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import '../../../../common/base/widgets/custom_app_bar.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../controller/profile_controller.dart';
import 'package:trip_wise_app/common/base/storage/local_data.dart';
import 'package:trip_wise_app/data/model/user/user_model.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/widgets/app_text_field.dart';
import 'package:trip_wise_app/common/base/widgets/app_button.dart';

class ProfilePage extends BasePage<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel? user = LocalData.shared.user;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'myAccount'.tr,
        showLeading: true,
        onTap: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Stack(
                children: [
                  Obx(() => CircleAvatar(
                        radius: 60,
                        backgroundImage: controller.selectedImage.value != null
                            ? FileImage(controller.selectedImage.value!)
                                as ImageProvider
                            : (user?.profilePicture != null)
                                ? NetworkImage(user!.profilePicture!)
                                    as ImageProvider
                                : const AssetImage(AppImages.imageUserDefault),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.color3461FD,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          AppImages.icEdit,
                          width: 20.w,
                          height: 20.h,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                user?.fullName ?? 'GFXAgency',
                style: AppStyles.STYLE_16.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.color0C092A,
                ),
              ),
              Text(
                user?.username ?? 'UI UX DESIGN',
                style: AppStyles.STYLE_14.copyWith(
                  color: AppColors.color7C8BA0,
                ),
              ),
              SizedBox(height: 30.h),
              AppTextFiled(
                labelText: 'email'.tr,
                controller: controller.emailController,
                height: 60.h,
                hintText: 'xxx@gmail.com',
                labelStyle: AppStyles.STYLE_14_BOLD
                    .copyWith(color: AppColors.color3B4054),
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    AppImages.icSms,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
                isReadOnly: true,
                isRequired: false,
              ),
              SizedBox(height: 12.h),
              AppTextFiled(
                labelText: 'username'.tr,
                labelStyle: AppStyles.STYLE_14_BOLD
                    .copyWith(color: AppColors.color3B4054),
                controller: controller.usernameController,
                height: 60.h,
                hintText: 'username'.tr,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    AppImages.icProfileCircle,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
                isRequired: false,
              ),
              SizedBox(height: 12.h),
              AppTextFiled(
                labelText: 'fullName'.tr,
                labelStyle: AppStyles.STYLE_14_BOLD
                    .copyWith(color: AppColors.color3B4054),
                controller: controller.fullNameController,
                height: 60.h,
                hintText: 'fullName'.tr,
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(
                    AppImages.icProfileCircle,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
                isRequired: false,
              ),
              SizedBox(height: 24.h),
              Obx(() => AppButton(
                    text: "saveChanges".tr,
                    onPressed: controller.hasChanges.value &&
                            !controller.isLoading.value
                        ? controller.saveChanges
                        : null,
                    bgColor: AppColors.color3461FD,
                    height: 60.h,
                    borderRadius: BorderRadius.circular(14.r),
                    isLoading: controller.isLoading.value,
                    unEnabled: !controller.hasChanges.value,
                  )),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
