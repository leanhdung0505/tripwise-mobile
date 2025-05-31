import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/data/model/itinerary/itinerary_model.dart';

import '../../../common/base/controller/observer_func.dart';
import '../../../common/repository/itinerary_repository.dart';
import '../../../data/response/places/itinerary_list_response.dart';
import '../../../data/response/places/pagination.dart';
import '../../../routes/app_routes.dart';

class ShareController extends BaseController {
  final ItineraryRepository itineraryRepository = Get.find();
  final RxList<ItineraryModel> itineraryList = <ItineraryModel>[].obs;
  final RxBool isLoading = false.obs;
  final ScrollController scrollController = ScrollController();
  final Rx<Pagination> pagination = Pagination().obs;

  @override
  void onInit() {
    super.onInit();
    getSharedItinerary();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100.h) {
        loadMore();
      }
    });
  }

  Future<void> getSharedItinerary({bool showLoading = true}) async {
    isLoading.value = true;
    subscribe(
      future: itineraryRepository.getSharedItinerary(),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          isLoading.value = false;
          final itineraryListResponse =
              ItineraryListResponse.fromJson(response.body);
          itineraryList.value = itineraryListResponse.itineraries ?? [];
        },
        onError: (error) {
          isLoading.value = false;
        },
      ),
    );
  }

  Future<void> refreshItineraryList() async {
    await Future.delayed(const Duration(microseconds: 500));
    await getSharedItinerary(showLoading: false);
  }

  Future<void> loadMore() async {
    if (isLoading.value || !(pagination.value.hasNext ?? false)) return;
    isLoading.value = true;
    subscribe(
      future: itineraryRepository.getSharedItinerary(),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          isLoading.value = false;
          final itineraryListResponse =
              ItineraryListResponse.fromJson(response.body);
          itineraryList.addAll(itineraryListResponse.itineraries ?? []);
        },
        onError: (error) {
          isLoading.value = false;
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
    );
  }

  void navigateToItineraryDetail(ItineraryModel itinerary) async {
    final result = await Get.toNamed(PageName.itineraryPage, arguments: {
      'itineraryId': itinerary.itineraryId,
    });

    if (result == true || result == 'deleted' || result == 'updated') {
      await refreshItineraryList();
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }
}
