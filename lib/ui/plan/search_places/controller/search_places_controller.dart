import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/utils/date_time_utils.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/place_repository.dart';
import '../../../../common/repository/place_repository_impl.dart';
import '../../../../common/repository/itinerary_repository.dart';
import '../../../../common/repository/itinerary_repository_impl.dart';
import '../../../../data/model/itinerary/activity_model.dart';
import '../../../../data/model/itinerary/place_model.dart';
import '../../../../data/response/places/pagination.dart';
import '../../../../data/response/places/place_list_response.dart';
import '../../../../routes/app_routes.dart';
import 'dart:async';

class SearchPlacesController extends BaseController {
  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearchActive = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<PlaceModel> places = <PlaceModel>[].obs;
  final RxList<PlaceModel> searchResults = <PlaceModel>[].obs;
  final PlaceRepository _placeRepository = PlaceRepositoryImpl();
  String selectedType = Get.arguments["type"];
  String startDate = Get.arguments["startDate"];
  String endDate = Get.arguments["endDate"];
  int itineraryId = Get.arguments["itineraryId"];
  int dayId = Get.arguments["dayId"];
  final ItineraryRepository _itineraryRepository = ItineraryRepositoryImpl();
  final ScrollController scrollSearchController = ScrollController();

  // Debouncer for search
  Timer? _debounce;

  // Pagination
  final Rx<Pagination?> pagination = Rx<Pagination?>(null);
  final RxBool isLoadingMore = false.obs;

  // Carousel functionality
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final RxInt currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getListPlace();
    scrollSearchController.addListener(() {
      if (scrollSearchController.position.pixels >
          scrollSearchController.position.maxScrollExtent - 100.h) {
        loadMore();
      }
    });
  }

  Future<void> getListPlace() async {
    subscribe(
      future: _placeRepository.getListPlace(type: selectedType),
      observer: ObserverFunc(
        onSubscribe: () {
          isLoading.value = true;
        },
        onSuccess: (response) {
          isLoading.value = false;
          final placeListResponse = PlaceListResponse.fromJson(response.body);
          places.value = placeListResponse.places ?? [];
          pagination.value = placeListResponse.pagination;
          searchResults.value = places;
        },
        onError: (error) {
          isLoading.value = false;
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
      isShowLoading: true,
    );
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        searchResults.value = places;
        return;
      }

      // Call API search
      searchPlace(query);
    });
  }

  Future<void> searchPlace(String query) async {
    isLoading.value = true;

    subscribe(
      future: _placeRepository.searchPlace(
        query: query,
        type: selectedType,
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final placeListResponse = PlaceListResponse.fromJson(response.body);
          searchResults.value = placeListResponse.places ?? [];
          isLoading.value = false;
        },
        onError: (error) {
          isLoading.value = false;
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
      isShowLoading: true,
    );
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !(pagination.value?.hasNext ?? false)) return;

    isLoadingMore.value = true;
    final nextPage = (pagination.value?.page ?? 0) + 1;

    subscribe(
      future: _placeRepository.getListPlace(
        type: selectedType,
        page: nextPage,
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final placeListResponse = PlaceListResponse.fromJson(response.body);
          places.addAll(placeListResponse.places ?? []);
          pagination.value = placeListResponse.pagination;
          searchResults.value = places;
          isLoadingMore.value = false;
        },
        onError: (error) {
          isLoadingMore.value = false;
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
    );
  }

  void activateSearch() {
    isSearchActive.value = true;
  }

  void deactivateSearch() {
    isSearchActive.value = false;
    searchController.clear();
    searchResults.value = places;
    FocusScope.of(Get.context!).unfocus();
  }

  void selectPlace(PlaceModel place) {
    Get.back(result: place);
  }

  void changeType(String type) {
    if (selectedType != type) {
      selectedType = type;
      getListPlace();
    }
  }

  String getFormattedPriceRange(String? priceRange) {
    if (priceRange == null || priceRange.isEmpty) {
      return "notAvailable".tr;
    }
    return priceRange;
  }

  String getFormattedRating(double? rating) {
    if (rating == null) {
      return "0.0";
    }
    return rating.toStringAsFixed(1);
  }

  List<String> getMealTypes(PlaceModel place) {
    if (place.restaurantDetail?.mealTypes == null ||
        place.restaurantDetail!.mealTypes!.isEmpty) {
      return ["noMealTypesAvailable".tr];
    }
    return place.restaurantDetail!.mealTypes!;
  }

  String? getPrimaryPhoto(PlaceModel place) {
    if (place.photos == null || place.photos!.isEmpty) {
      return place.image;
    }
    final primaryPhoto =
        place.photos!.firstWhereOrNull((photo) => photo.isPrimary ?? false);
    return primaryPhoto?.photoUrl ?? place.photos!.first.photoUrl;
  }

  // Carousel functions
  void onPageChanged(int index) {
    currentPageIndex.value = index;
    // Load more when user reaches near the end of carousel
    if (index >= places.length - 2 && !isLoadingMore.value) {
      loadMore();
    }
  }

  void selectAttraction(int index) {
    carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToPlaceDetails(PlaceModel place) {
    Get.toNamed(PageName.activityDetailPage, arguments: {
      "place": place,
      "dayNumber": -1,
      "itineraryId": itineraryId,
      "dayId": dayId,
    });
  }

  void navigateToMap(PlaceModel place) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current position
    final position = await Geolocator.getCurrentPosition();
    final activityModel = ActivityModel(
      itineraryActivityId: 0,
      dayId: 0,
      placeId: place.placeId,
      startTime: DateTime.now().toIso8601String(),
      place: PlaceModel(
        placeId: place.placeId,
        name: place.name,
        localName: place.localName,
        description: place.description,
        type: place.type,
        address: place.address,
        city: place.city,
        latitude: place.latitude,
        longitude: place.longitude,
        rating: place.rating,
        priceRange: place.priceRange,
        phone: place.phone,
        email: place.email,
        website: place.website,
        webUrl: place.webUrl,
        image: place.image,
        photos: place.photos,
        numberReview: place.numberReview,
      ),
    );

    Get.toNamed(
      PageName.mapPage,
      arguments: {
        'showRoute': true,
        'startLat': position.latitude,
        'startLng': position.longitude,
        'endLat': place.latitude,
        'endLng': place.longitude,
        'activityIndex': 0,
        'showCurrentLocation': true,
        'activities': [activityModel],
        'dayNumber': -1,
      },
    );
  }

  Future<void> addActivityToItinerary(
      PlaceModel place, DateTime startTime) async {
    subscribe(
      future: _itineraryRepository.addActivityItinerary(dayId, body: {
        "place_id": place.placeId,
        "start_time": startTime.formatTime().toString(),
      }),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "activityAddedToItinerary".tr);
          onNavigateItineraryPage();
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
      isShowLoading: true,
    );
  }
  Future<void> editHotel(PlaceModel place) async {
    subscribe(
      future: _itineraryRepository.updateItinerary(itineraryId, body: {
        "hotel_id": place.placeId,
      }),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "hotelEdited".tr);
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "errorOccurred".tr);
        },
      ),
      isShowLoading: true,
    );
  }
  void onNavigateItineraryPage() {
    Get.offNamedUntil(
      PageName.itineraryPage,
      (route) => route.settings.name == PageName.mainPage,
      arguments: {
        'itineraryId': itineraryId,
        'dayId': dayId,
      },
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    scrollSearchController.dispose();
    super.onClose();
  }
}
