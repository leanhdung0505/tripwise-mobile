import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rive/rive.dart' as rive;
import 'package:trip_wise_app/resource/theme/app_style.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../controller/process_loading_controller.dart';

class ProcessLoadingPage extends StatefulWidget {
  const ProcessLoadingPage({super.key});

  @override
  State<ProcessLoadingPage> createState() => _ProcessLoadingPageState();
}

class _ProcessLoadingPageState extends State<ProcessLoadingPage> {
  final ProcessLoadingController controller =
      Get.find<ProcessLoadingController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onGenerateAiPlanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 400.h,
            child: const rive.RiveAnimation.asset(AppImages.travelAppAnimation,
                fit: BoxFit.cover),
          ),
          Text(
            "generateAiItinerary".tr,
            style: AppStyles.STYLE_24_BOLD.copyWith(
              color: AppColors.color3461FD,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            "generateAiItineraryDescription".tr,
            style: AppStyles.STYLE_14.copyWith(
              color: AppColors.color3B4054.withOpacity(0.5),
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60.h),
          Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${controller.progress.value.toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: AppStyles.STYLE_16_BOLD.copyWith(
                    color: AppColors.color0AA3E4,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 24.h),
                LinearPercentIndicator(
                  animation: false,
                  lineHeight: 20.h,
                  animationDuration: 300,
                  percent: controller.progress.value / 100,
                  backgroundColor: AppColors.color7C8BA0.withOpacity(0.2),
                  linearGradient: const LinearGradient(
                    colors: [
                      AppColors.color34D8FD,
                      AppColors.color3461FD,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  barRadius: Radius.circular(10.r),
                ),
                SizedBox(height: 16.h),
                Text(
                  'generateAiItineraryFooter'.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.STYLE_16_BOLD.copyWith(
                    color: AppColors.color7C8BA0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
