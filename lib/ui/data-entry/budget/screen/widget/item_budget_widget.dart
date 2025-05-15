import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import 'package:trip_wise_app/ui/data-entry/budget/model/budget_model.dart';

import '../../../../../resource/theme/app_colors.dart';
import '../../controller/budget_controller.dart';

// ignore: must_be_immutable
class ItemBudgetWidget extends StatelessWidget {
  ItemBudgetWidget(this.budgetModel, {super.key});

  final BudgetModel budgetModel;
  final controller = Get.find<BudgetController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.onBudgetSelected(budgetModel);
      },
      child: Obx(
        () => Container(
          width: 100.h,
          height: 100.h,
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: budgetModel.isSelected.value
                ? const Color(0xFF3461FD)
                : const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 4.h,
              ),
              Obx(
                () => Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    budgetModel.image.value,
                    height: 35.h,
                    width: 35.h,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 20.h,
                ),
                child: Text(
                  budgetModel.name.value,
                  style: AppStyles.STYLE_14.copyWith(
                    color: budgetModel.isSelected.value
                        ? AppColors.white
                        : AppColors.color0C092A,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
