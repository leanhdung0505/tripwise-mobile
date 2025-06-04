import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/observer_func.dart';
import 'package:trip_wise_app/common/repository/itinerary_repository.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import 'package:trip_wise_app/utils/date_time_utils.dart';
import '../../../../common/repository/itinerary_repository_impl.dart';
import '../../../../common/repository/user_repository.dart';
import '../../../../common/repository/user_repository_impl.dart';
import '../../../../data/model/itinerary/activity_model.dart';
import '../../../../data/model/itinerary/itinerary_model.dart';
import '../../../../data/model/itinerary/day_model.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../data/model/user/user_minimal_model.dart';
import '../../../../data/request/itinerary/update_time_request.dart';
import '../../../../utils/distance_utils.dart';

class ItineraryController extends BaseController {
  static ItineraryController get to => Get.find<ItineraryController>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isScrolled = false.obs;
  final ItineraryRepository _itineraryRepository = ItineraryRepositoryImpl();
  final UserRepository _userRepository = UserRepositoryImpl();
  Rxn<ItineraryModel> itineraryModel = Rxn<ItineraryModel>();
  RxBool isLoading = true.obs;
  int itineraryId = Get.arguments["itineraryId"];

  // Added for user search
  final RxList<UserMinimalModel> searchResults = <UserMinimalModel>[].obs;
  final RxBool isLoadingMore = false.obs;
  Timer? _debounce;

  // Added for managing shared users permissions
  final RxMap<String, String> permissionChanges = <String, String>{}.obs;
  final RxList<UserMinimalModel> sharedUsers = <UserMinimalModel>[].obs;

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
    Get.back(result: 'updated');
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

  void navigateToSearchPlacesPage(String type) {
    Get.toNamed(PageName.searchPlacesPage, arguments: {
      "itineraryId": itineraryId,
      "type": type,
      "startDate": itineraryModel.value!.startDate,
      "endDate": itineraryModel.value!.endDate,
      "dayId": selectedDay!.dayId,
    });
  }

  Future<void> getDetailItinerary() async {
    subscribe(
      future: _itineraryRepository.getDetailItinerary(itineraryId),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final itineraryDetailResponse =
              ItineraryModel.fromJson(response.body['data']);
          itineraryModel.value = itineraryDetailResponse;

          // Update shared users list
          if (itineraryDetailResponse.sharedUsers != null) {
            sharedUsers.value = itineraryDetailResponse.sharedUsers!;
          }

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

  Future<void> deleteItinerary() async {
    isLoading.value = true;
    subscribe(
      future: _itineraryRepository
          .deleteItinerary(itineraryModel.value!.itineraryId!),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          Get.back(result: 'deleted');
          showSimpleSuccessSnackBar(message: response.body["detail"] ?? "");
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isLoading.value = false;
        },
      ),
    );
  }

  Future<void> deleteActivity(int activityId) async {
    isLoading.value = true; // Set loading state to true before deleting
    subscribe(
      future: _itineraryRepository.deleteActivityItinerary(activityId),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) async {
          showSimpleSuccessSnackBar(message: response.body["detail"] ?? "");
          await getDetailItinerary();
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isLoading.value = false;
        },
      ),
    );
  }

  Future<void> deleteDay(int dayId) async {
    isLoading.value = true;
    subscribe(
      future: _itineraryRepository.deleteDayItinerary(dayId),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) async {
          showSimpleSuccessSnackBar(message: response.body["detail"] ?? "");
          await getDetailItinerary();
          selectedDayIndex.value = 0;
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isLoading.value = false;
        },
      ),
    );
  }

  Future<void> changeTimeActivity(int activityId, String newTime) async {
    isLoading.value = true;
    final UpdateTimeRequest timeRequest = UpdateTimeRequest(
      startTime: newTime,
    );
    subscribe(
      future: _itineraryRepository.updateActivityItinerary(
        activityId,
        body: timeRequest.toJson(),
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) async {
          showSimpleSuccessSnackBar(message: "timeUpdatedSuccess".tr);
          await getDetailItinerary();
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isLoading.value = false;
        },
      ),
    );
  }

  Future<void> addDay(DateTime date) async {
    isLoading.value = true;
    subscribe(
      future: _itineraryRepository.addDayItinerary(itineraryId, body: {
        "date": date.formatDateNoText().toString(),
      }),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) async {
          showSimpleSuccessSnackBar(message: "addDaySuccess".tr);
          await getDetailItinerary();
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isLoading.value = false;
        },
      ),
    );
  }

  Future<void> addToFavorite() async {
    subscribe(
      future: _itineraryRepository.addToFavoriteItinerary(itineraryId),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "addToFavoriteSuccess".tr);
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
      isShowLoading: true,
    );
  }

  Future<void> removeFromFavorite() async {
    subscribe(
      future: _itineraryRepository.removeFromFavoriteItinerary(itineraryId),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "removeFromFavoriteSuccess".tr);
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
      isShowLoading: true,
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
        currentImageIndex.value =
            (currentImageIndex.value + 1) % headerImages.length;
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

  Map<String, double?> getCoordinatesBetweenActivities(int currentIndex) {
    if (selectedDay == null ||
        selectedDay!.activities == null ||
        selectedDay!.activities!.isEmpty ||
        currentIndex >= selectedDay!.activities!.length - 1) {
      return {
        'startLat': null,
        'startLng': null,
        'endLat': null,
        'endLng': null,
      };
    }

    final currentActivity = selectedDay!.activities![currentIndex];
    final nextActivity = selectedDay!.activities![currentIndex + 1];

    return {
      'startLat': currentActivity.place?.latitude,
      'startLng': currentActivity.place?.longitude,
      'endLat': nextActivity.place?.latitude,
      'endLng': nextActivity.place?.longitude,
    };
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

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchUsersToShare(query);
    });
  }

  Future<void> searchUsersToShare(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    subscribe(
      future: _userRepository.searchUsersToShare(query, itineraryId.toString()),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          if (response.body['data'] != null) {
            final List<dynamic> usersJson = response.body['data'];
            final users = usersJson
                .map((json) => UserMinimalModel.fromJson(json))
                .toList();
            searchResults.value = users;
          } else {
            searchResults.clear();
          }
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          searchResults.clear();
        },
      ),
    );
  }

  Future<void> shareItinerary(String userId, String permission) async {
    isLoading.value = true;
    subscribe(
      future: _itineraryRepository.shareItinerary(body: {
        "itinerary_id": itineraryId.toString(),
        "shared_with_user_id": userId,
        "permission": permission,
      }),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          showSimpleSuccessSnackBar(message: "shareSuccess".tr);
          isLoading.value = false;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
    );
  }

  Future<void> updateSharedUserPermissions() async {
    if (permissionChanges.isEmpty) return;

    isLoading.value = true;
    final List<Map<String, String>> updates = [];

    permissionChanges.forEach((userId, permission) {
      updates.add({"shared_with_user_id": userId, "permission": permission});
    });

    final Map<String, dynamic> requestBody = {
      "itinerary_id": itineraryId,
      "updates": updates
    };

    subscribe(
      future:
          _itineraryRepository.updateSharedUserPermission(body: requestBody),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) async {
          permissionChanges.clear();
          await getDetailItinerary();
          isLoading.value = false;
          showSimpleSuccessSnackBar(message: "updatePermissionsSuccess".tr);
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isLoading.value = false;
        },
      ),
    );
  }

  void updateUserPermission(String userId, String newPermission) {
    if (sharedUsers.any(
        (user) => user.userId == userId && user.permissions != newPermission)) {
      permissionChanges[userId] = newPermission;
    } else {
      permissionChanges.remove(userId);
    }
  }

  void clearPermissionChanges() {
    permissionChanges.clear();
    // Reset permissions to original state
    if (itineraryModel.value?.sharedUsers != null) {
      sharedUsers.value = itineraryModel.value!.sharedUsers!;
    }
  }

  Future<void> refreshItineraryList() async {
    await getDetailItinerary();
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    _imageTimer?.cancel();
    super.onClose();
  }
}
