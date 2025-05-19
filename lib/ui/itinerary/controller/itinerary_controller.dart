import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/date_time_utils.dart';
import '../../../common/base/controller/base_controller.dart';
import '../model/destination.dart';

class ItineraryController extends BaseController {
  static ItineraryController get to => Get.find<ItineraryController>();
  final ScrollController scrollController = ScrollController();
  final RxBool isScrolled = false.obs;
  final DateTime startDate = Get.arguments['startDate'];
  final DateTime endDate = Get.arguments['endDate'];

  
  late final Rx<Destination> destination;

  @override
  void onInit() {
    super.onInit();
    destination = Destination(
      name: 'Da Nang',
      country: 'Viet Nam',
      days: 3,
      startDate: startDate.formatMonthDate(),
      endDate: endDate.formatMonthDate(),
      images: ['assets/images/danang.jpg'],
    ).obs;
  }

  void onNavigatePreviousPage() {
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
