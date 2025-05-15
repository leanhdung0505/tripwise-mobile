import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/ui/data-entry/budget/model/list_budget.dart';

import '../model/budget_model.dart';

class BudgetController extends BaseController {
  static BudgetController get to => Get.find<BudgetController>();
  RxString selectedBudget = ''.obs;
  RxBool isEnabledButton = false.obs;
  Rx<ListBudget> budgets = ListBudget().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onBudgetSelected(BudgetModel budget) {
    for (var item in budgets.value.listBudget.value) {
      item.isSelected.value = false;
    }
    // Đặt mục được chọn
    budget.isSelected.value = true;
    selectedBudget.value = budget.name.value;
    checkStatus();
  }

  void checkStatus() {
    isEnabledButton.value = selectedBudget.value.isNotEmpty;
  }

  void onGenerate() {
    print("Selected budget: $selectedBudget");
  }

  @override
  void onClose() {
    super.onClose();
  }
}
