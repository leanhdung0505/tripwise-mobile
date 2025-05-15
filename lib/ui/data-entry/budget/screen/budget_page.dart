import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import 'package:trip_wise_app/ui/data-entry/budget/controller/budget_controller.dart';
import 'package:trip_wise_app/ui/data-entry/budget/model/budget_model.dart';
import 'package:trip_wise_app/ui/data-entry/budget/screen/widget/item_budget_widget.dart';

import '../../../../common/base/widgets/app_button.dart';
import '../../../../common/base/widgets/custom_app_bar.dart';
import '../../../../resource/asset/app_images.dart';
import '../../../../resource/theme/app_colors.dart';
import '../../../../resource/theme/app_style.dart';

class BudgetPage extends BasePage<BudgetController> {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _buildAppBar(),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 34.h),
          child: Column(
            children: [
              _buildYourBudgetRow(),
              SizedBox(height: 10.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "budgetDescription".tr,
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColors.color0C092A,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20.h),
              _buildBudgetForm(),
              const Spacer(),
              Obx(
                () => AppButton(
                  text: "generate_ai_itinerary".tr,
                  onPressed: controller.onGenerate,
                  height: 50.h,
                  width: 300.w,
                  borderRadius: BorderRadius.circular(12.r),
                  unEnabled: !controller.isEnabledButton.value,
                  textColor: AppColors.white,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.color0AE4E4,
                      AppColors.color3461FD,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top),
      child: CustomAppBar(
        showLeading: true,
        onTap: Get.back,
        fillColor: AppColors.white,
        showShadow: false,
        title: null,
        actions: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40.h,
                      width: 40.h,
                      decoration: const BoxDecoration(
                        color: AppColors.colorE6E6E6,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.black,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "step".trParams({"step": "4/4"}),
                          style: AppStyles.STYLE_14.copyWith(
                            color: AppColors.color3461FD,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: Container(
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: AppColors.colorE6E6E6,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w),
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.color3461FD,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourBudgetRow() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.colorE4CB0A,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.icCalendar,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "budgetTitle".tr,
            style: AppStyles.STYLE_20_BOLD.copyWith(
              color: AppColors.color0C092A,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetForm() {
    return SizedBox(
      width: double.maxFinite,
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 10.h,
            children: List.generate(
              controller.budgets.value.listBudget.value.length,
              (index) {
                BudgetModel model =
                    controller.budgets.value.listBudget.value[index];
                return ItemBudgetWidget(model);
              },
            ),
          ),
        ),
      ),
    );
  }
}
