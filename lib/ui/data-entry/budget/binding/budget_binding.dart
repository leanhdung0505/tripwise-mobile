import 'package:get/get.dart';
import 'package:trip_wise_app/ui/data-entry/budget/controller/budget_controller.dart';

class BudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BudgetController>(BudgetController());
  }
}
