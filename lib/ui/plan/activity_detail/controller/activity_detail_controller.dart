import 'package:get/get.dart';
import 'package:trip_wise_app/utils/date_time_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/repository/itinerary_repository.dart';
import '../../../../common/repository/itinerary_repository_impl.dart';
import '../../../../data/model/itinerary/activity_model.dart';
import '../../../../data/model/itinerary/place_model.dart';
import '../../../../routes/app_routes.dart';

class ActivityDetailController extends BaseController {
  static ActivityDetailController get to =>
      Get.find<ActivityDetailController>();

  Rxn<PlaceModel> place = Rxn<PlaceModel>();
  RxInt currentImageIndex = 0.obs;
  RxList<String> images = <String>[].obs;
  int? dayNumber;
  final ItineraryRepository _itineraryRepository = ItineraryRepositoryImpl();
  int itineraryId = Get.arguments["itineraryId"];
  int dayId = Get.arguments["dayId"];
  @override
  void onInit() {
    super.onInit();
    _initializePlace();
  }

  void _initializePlace() {
    final arguments = Get.arguments;
    if (arguments != null && arguments['place'] != null) {
      place.value = arguments['place'] as PlaceModel;
      dayNumber = arguments['dayNumber'] as int?;

      _setupImages();
    }
  }

  void _setupImages() {
    final List<String> placeImages = [];

    // Add main image if available
    if (place.value?.image != null && place.value!.image!.isNotEmpty) {
      placeImages.add(place.value!.image!);
    }

    // Add photos if available
    if (place.value?.photos != null && place.value!.photos!.isNotEmpty) {
      for (final photo in place.value!.photos!) {
        if (photo.photoUrl != null && photo.photoUrl!.isNotEmpty) {
          placeImages.add(photo.photoUrl!);
        }
      }
    }

    // If no images available, use placeholder
    if (placeImages.isEmpty) {
      placeImages.addAll([
        'https://picsum.photos/400/300',
        'https://picsum.photos/400/301',
        'https://picsum.photos/400/302',
      ]);
    }

    images.value = placeImages.toSet().toList(); // Remove duplicates
  }

  void updateCurrentImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void onNavigateBack() {
    Get.back();
  }

  void openWebsite() async {
    if (place.value == null) return;

    String? urlToOpen;

    if (place.value?.website != null && place.value!.website!.isNotEmpty) {
      urlToOpen = place.value!.website!;
    } else if (place.value?.webUrl != null && place.value!.webUrl!.isNotEmpty) {
      urlToOpen = place.value!.webUrl!;
    }

    if (urlToOpen != null) {
      try {
        final Uri url = Uri.parse(urlToOpen);
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        showSimpleErrorSnackBar(message: e.toString());
      }
    } else {
      showSimpleErrorSnackBar(message: 'noWebsiteAvailable'.tr);
    }
  }

  String get placeName {
    if (place.value == null) return 'Unknown Place';

    return Get.locale?.languageCode == 'vi'
        ? (place.value!.localName ?? place.value!.name ?? 'Unknown Place')
        : (place.value!.name ?? 'Unknown Place');
  }

  String get placeDescription {
    final description = place.value?.description;
    if (description != null && description.isNotEmpty) {
      return description;
    }

    final placeType = place.value?.type;
    switch (placeType) {
      case 'RESTAURANT':
        return 'defaultRestaurantDesc'.tr;
      case 'ATTRACTION':
        return 'defaultAttractionDesc'.tr;
      case 'HOTEL':
        return 'defaultHotelDesc'.tr;
      default:
        return 'defaultPlaceDesc'.tr;
    }
  }

  double get rating => place.value?.rating ?? 4.5;

  int get reviewCount => place.value?.numberReview ?? 0;

  void navigateToMap() {
    if (place.value != null) {
      final activityModel = ActivityModel(
        itineraryActivityId: 0,
        dayId: 0,
        placeId: place.value!.placeId,
        startTime: DateTime.now().toIso8601String(),
        place: PlaceModel(
          placeId: place.value!.placeId,
          name: place.value!.name,
          localName: place.value!.localName,
          description: place.value!.description,
          type: place.value!.type,
          address: place.value!.address,
          city: place.value!.city,
          latitude: place.value!.latitude,
          longitude: place.value!.longitude,
          rating: place.value!.rating,
          priceRange: place.value!.priceRange,
          phone: place.value!.phone,
          email: place.value!.email,
          website: place.value!.website,
          webUrl: place.value!.webUrl,
          image: place.value!.image,
          photos: place.value!.photos,
          numberReview: place.value!.numberReview,
        ),
      );

      Get.toNamed(
        PageName.mapPage,
        arguments: {
          'activities': [activityModel],
          'dayNumber': 0,
        },
      );
    }
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
    );
  }

  void onNavigateItineraryPage() {
    Get.offNamedUntil(
      PageName.itineraryPage,
      (route) => route.settings.name == PageName.mainPage,
      arguments: {
        'itineraryId': itineraryId,
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
