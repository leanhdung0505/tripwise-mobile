import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';

import '../../../../routes/app_routes.dart';
import '../models/interest_model.dart';
import '../models/list_interest.dart';

class InterestsController extends BaseController {
  static InterestsController get to => Get.find<InterestsController>();
  RxList<String> selectedInterests = <String>[].obs;
  RxBool isEnabledButton = false.obs;
  Rx<ListInterest> interests = ListInterest().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void toggleInterest(String interestName) {
    InterestModel? foundInterest;
    for (var interest in interests.value.listInterest.value) {
      if (interest.name.value == interestName) {
        foundInterest = interest;
        break;
      }
    }
    if (foundInterest != null) {
      foundInterest.isSelected.value = !foundInterest.isSelected.value;
      
      if (foundInterest.isSelected.value) {
        if (!selectedInterests.contains(interestName)) {
          selectedInterests.add(interestName);
        }
      } else {
        selectedInterests.remove(interestName);
      }
      checkStatus();
    }
  }

  void checkStatus() {
    isEnabledButton.value = selectedInterests.isNotEmpty;
  }

  void onNext() {
    print("Selected interests: $selectedInterests");
    Get.toNamed(PageName.budgetPage, arguments: {
      'selectedInterests': selectedInterests,
      'startDate': Get.arguments['startDate'],
      'endDate': Get.arguments['endDate'],
      'days': Get.arguments['days'],
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}