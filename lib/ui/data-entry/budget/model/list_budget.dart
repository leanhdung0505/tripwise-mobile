import 'package:get/get.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';

import 'budget_model.dart';

class ListBudget {
  Rx<List<BudgetModel>> listBudget = 
  Rx(
    [
      BudgetModel(
        id: '1',
        name: 'economy'.tr,
        image: AppImages.icEconomy,
        isSelected: false,
        value: 'Economy',
      ),
      BudgetModel(
        id: '2',
        name: 'normal'.tr,
        image: AppImages.icNormal,
        isSelected: false,
        value: 'Normal',
      ),
      BudgetModel(
        id: '3',
        name: 'luxury'.tr,
        image: AppImages.icLuxury,
        isSelected: false,
        value: 'Luxury',
      ),
    ],
  );
}