import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

import '../../../common/base/controller/observer_func.dart';
import '../../../common/repository/itinerary_repository.dart';
import '../../../data/model/itinerary/itinerary_model.dart';
import '../../../data/response/places/itinerary_list_response.dart';
import '../../../data/response/places/pagination.dart';

class HomeController extends BaseController {
  final ItineraryRepository _itineraryRepository = Get.find();
  final RxList<ItineraryModel> itineraryList = <ItineraryModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<Pagination> pagination = Pagination().obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getItinerary();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent-100.h) {
        loadMore();
      }
    });
    refreshItineraryList();
  }

  Future<void> getItinerary({bool showLoading = true}) async {
    subscribe(
      future: _itineraryRepository.getListItinerary(),
      observer: ObserverFunc(
        onSubscribe: () {
          if (showLoading) {
            isLoading.value = true;
          }
        },
        onSuccess: (response) {
          isLoading.value = false;
          final itineraryListResponse =
              ItineraryListResponse.fromJson(response.body);
          itineraryList.value = itineraryListResponse.itineraries ?? [];
          pagination.value = itineraryListResponse.pagination ?? Pagination();
        },
        onError: (error) {
          isLoading.value = false;
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
    );
  }

  Future<void> refreshItineraryList() async {
    await Future.delayed(const Duration(microseconds: 500));
    await getItinerary(showLoading: false);
  }

  Future<void> loadMore() async {
    if (isLoading.value || !(pagination.value.hasNext ?? false)) return;

    isLoading.value = true;
    final nextPage = (pagination.value.page ?? 0) + 1;

    subscribe(
      future: _itineraryRepository.getListItinerary(page: nextPage),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          isLoading.value = false;
          final itineraryListResponse =
              ItineraryListResponse.fromJson(response.body);
          itineraryList.addAll(itineraryListResponse.itineraries ?? []);
          pagination.value = itineraryListResponse.pagination ?? Pagination();
        },
        onError: (error) {
          isLoading.value = false;
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
    );
  }

  void navigateToDuration() {
    Get.toNamed(PageName.durationPage);
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
    scrollController.dispose();
    super.onClose();
  }
}