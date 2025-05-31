import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/ui/data-entry/interests/models/interest_model.dart';

import '../../../../../resource/asset/app_images.dart';
import '../../../../../resource/theme/app_colors.dart';
import '../../../../../resource/theme/app_style.dart';
import '../../controller/interests_controller.dart';

// ignore: must_be_immutable
class ItemInterestWidget extends StatelessWidget {
  ItemInterestWidget(this.interestModel, {super.key});
  InterestModel interestModel;
  var controller = Get.find<InterestsController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 4.h,
        vertical: 4.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => SvgPicture.asset(
              interestModel.image.value,
              height: 24.h,
              width: 24.h,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 18.h,
            ),
            child: Obx(
              () => Text(
                interestModel.name.value,
                style: AppStyles.STYLE_14.copyWith(
                  color: AppColors.color0C092A,
                ),
              ),
            ),
          ),
          const Spacer(),
          Obx(
            () => GestureDetector(
              onTap: () {
                controller.toggleInterest(interestModel.value.value);
              },
              child: SvgPicture.asset(
                interestModel.isSelected.value
                    ? AppImages.icToggleOn
                    : AppImages.icToggleOff,
                height: 24.h,
                width: 24.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
