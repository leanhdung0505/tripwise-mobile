import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/ui/data-entry/budget/model/list_budget.dart';
import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/itinerary_repository.dart';
import '../../../../data/request/itinerary/create_manual_itinerary.dart';
import '../../../../routes/app_routes.dart';
import '../model/budget_model.dart';

class BudgetController extends BaseController {
  static BudgetController get to => Get.find<BudgetController>();
  RxString selectedBudget = ''.obs;
  RxBool isEnabledButton = false.obs;
  Rx<ListBudget> budgets = ListBudget().obs;
  int itineraryId = 11;
  ItineraryRepository itineraryRepository = Get.find();

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
    selectedBudget.value = budget.value.value;
    checkStatus();
  }

  void checkStatus() {
    isEnabledButton.value = selectedBudget.value.isNotEmpty;
  }

  Future<void> createManualItinerary() async {
    subscribe(
      future: itineraryRepository.postItinerary(
        body: CreateManualItineraryModel(
          budgetCategory: selectedBudget.value,
          startDate: Get.arguments['startDate'],
          endDate: Get.arguments['endDate'],
          destinationCity: "Da Nang",
          title: "Itinerary manual",
          description: "Itinerary manual",
          hotelId: 591,
        ).toJson(),
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "createManualItinerarySuccess".tr);
          Get.until((route) => route.settings.name == PageName.mainPage);
          Get.toNamed(PageName.itineraryPage,
              arguments: {'itineraryId': response.body['data']['itinerary_id']});
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
    );
  }

  void onNavigateProcessLoadingPage() {
    if (isEnabledButton.value) {
      Get.toNamed(PageName.processLoadingPage, arguments: {
        'startDate': Get.arguments['startDate'],
        'endDate': Get.arguments['endDate'],
        'budget': selectedBudget.value,
        'selectedInterests': Get.arguments['selectedInterests'],
        'days': Get.arguments['days'],
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
