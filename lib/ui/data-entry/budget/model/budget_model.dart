import 'package:get/get.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';

class BudgetModel {
  RxString id = ''.obs;
  RxString name = ''.obs;
  Rx<String> image = Rx(AppImages.earth);
  RxBool isSelected = false.obs;

  BudgetModel({
    required String id,
    required String name,
    required String image,
    required bool isSelected,
  }) {
    this.id.value = id;
    this.name.value = name;
    this.image.value = image;
    this.isSelected.value = isSelected;
  }
}
