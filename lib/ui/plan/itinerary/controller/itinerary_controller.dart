import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/observer_func.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import '../../../../data/model/itinerary/activity_model.dart';
import '../../../../data/model/itinerary/itinerary_model.dart';
import '../../../../data/model/itinerary/day_model.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../utils/distance_utils.dart';

class ItineraryController extends BaseController {
  static ItineraryController get to => Get.find<ItineraryController>();
  final ScrollController scrollController = ScrollController();
  final RxBool isScrolled = false.obs;
  final ItineraryRepository _itineraryRepository = Get.find();
  Rxn<ItineraryModel> itineraryModel = Rxn<ItineraryModel>();
  RxBool isLoading = true.obs;
  
  // Added for tab functionality
  RxInt selectedDayIndex = 0.obs;
  RxList<DayModel> days = <DayModel>[].obs;
  
  // Added for header image carousel
  RxList<String> headerImages = <String>[].obs;
  RxInt currentImageIndex = 0.obs;
  Timer? _imageTimer;

  @override
  void onInit() {
    super.onInit();
    getDetailItinerary();
  }

  void onNavigatePreviousPage() {
    Get.back();
  }

  void selectDay(int index) {
    if (index >= 0 && index < days.length) {
      selectedDayIndex.value = index;
    }
  }

  void navigateToMapPage() {
    if (selectedDay == null ||
        selectedDay!.activities == null ||
        selectedDay!.activities!.isEmpty) {
      showSimpleErrorSnackBar(message: "No activities found to display on map");
      return;
    }

    final validActivities = selectedDay!.activities!.where((activity) {
      return activity.place != null &&
          activity.place!.latitude != null &&
          activity.place!.longitude != null;
    }).toList();

    if (validActivities.isEmpty) {
      showSimpleErrorSnackBar(
          message: "No valid location data to display on map");
      return;
    }

    validActivities.sort((a, b) {
      if (a.startTime == null || b.startTime == null) return 0;
      return a.startTime!.compareTo(b.startTime!);
    });

    Get.toNamed(PageName.mapPage, arguments: {
      "activities": validActivities,
      "dayNumber": selectedDay!.dayNumber
    });
  }

  Future<void> getDetailItinerary() async {
    subscribe(
      future: _itineraryRepository.getDetailItinerary(2),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final itineraryDetailResponse =
              ItineraryModel.fromJson(response.body['data']);
          itineraryModel.value = itineraryDetailResponse;

          if (itineraryDetailResponse.days != null &&
              itineraryDetailResponse.days!.isNotEmpty) {
            days.value = itineraryDetailResponse.days!;
          } else {
            _createDummyDays();
          }
          
          // Extract and setup header images
          _setupHeaderImages();
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          _createDummyDays();
          _setupHeaderImages();
        },
      ),
    );
  }

  void _createDummyDays() {
    final List<DayModel> dummyDays = [];
    final DateTime today = DateTime.now();

    for (int i = 0; i < 3; i++) {
      final day = DayModel(
        dayNumber: i + 1,
        date: today.add(Duration(days: i)).toIso8601String(),
        dayId: i + 1,
        itineraryId: 1,
        activities: [],
      );
      dummyDays.add(day);
    }

    days.value = dummyDays;
  }

  void _setupHeaderImages() {
    final List<String> images = [];
    
    for (final day in days) {
      if (day.activities != null) {
        for (final activity in day.activities!) {
          // Check if place has images
          if (activity.place?.image != null && 
              activity.place!.image!.isNotEmpty) {
            images.add(activity.place!.image!);
          }
          
          // Check if place has photos
          if (activity.place?.photos != null && 
              activity.place!.photos!.isNotEmpty) {
            for (final photo in activity.place!.photos!) {
              if (photo.photoUrl != null && photo.photoUrl!.isNotEmpty) {
                images.add(photo.photoUrl!);
              }
            }
          }
        }
      }
    }
    headerImages.value = images.toSet().toList();
    if (headerImages.isEmpty) {
      headerImages.value = [AppImages.earth]; 
    }
    
    // Start image rotation timer
    _startImageRotation();
  }

  void _startImageRotation() {
    // Cancel existing timer if any
    _imageTimer?.cancel();
    
    // Only start timer if we have multiple images
    if (headerImages.length > 1) {
      _imageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        currentImageIndex.value = (currentImageIndex.value + 1) % headerImages.length;
      });
    }
  }

  List<DayModel> get visibleDays => days;

  DayModel? get selectedDay => selectedDayIndex.value < days.length
      ? days[selectedDayIndex.value]
      : null;

  String calculateDistanceBetweenActivities(
      ActivityModel? fromActivity, ActivityModel? toActivity) {
    if (fromActivity == null || toActivity == null) {
      return "0 km";
    }

    final double? fromLat = fromActivity.place?.latitude;
    final double? fromLng = fromActivity.place?.longitude;
    final double? toLat = toActivity.place?.latitude;
    final double? toLng = toActivity.place?.longitude;

    final double distance =
        DistanceUtils.calculateDistance(fromLat, fromLng, toLat, toLng);
    return DistanceUtils.formatDistance(distance);
  }

  String estimateTravelTime(double distanceInKm) {
    final double timeInHours = distanceInKm / 45;
    final int timeInMinutes = (timeInHours * 60).round();
    if (timeInMinutes < 60) {
      return "minute".trParams({"minute": timeInMinutes.toString()});
    } else {
      final int hours = timeInMinutes ~/ 60;
      final int minutes = timeInMinutes % 60;
      return "hour"
          .trParams({"hour": hours.toString(), "minute": minutes.toString()});
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    _imageTimer?.cancel();
    super.onClose();
  }
}