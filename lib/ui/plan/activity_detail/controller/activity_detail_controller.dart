import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../data/model/itinerary/activity_model.dart';
import '../../../../routes/app_routes.dart';

class ActivityDetailController extends BaseController {
  static ActivityDetailController get to =>
      Get.find<ActivityDetailController>();

  Rxn<ActivityModel> activity = Rxn<ActivityModel>();
  RxInt currentImageIndex = 0.obs;
  RxList<String> images = <String>[].obs;
  int? dayNumber;

  @override
  void onInit() {
    super.onInit();
    _initializeActivity();
  }

  void _initializeActivity() {
    final arguments = Get.arguments;
    if (arguments != null && arguments['activity'] != null) {
      activity.value = arguments['activity'] as ActivityModel;
      dayNumber = arguments['dayNumber'] as int?;

      _setupImages();
    }
  }

  void _setupImages() {
    final List<String> activityImages = [];

    // Add main image if available
    if (activity.value?.place?.image != null &&
        activity.value!.place!.image!.isNotEmpty) {
      activityImages.add(activity.value!.place!.image!);
    }

    // Add photos if available
    if (activity.value?.place?.photos != null &&
        activity.value!.place!.photos!.isNotEmpty) {
      for (final photo in activity.value!.place!.photos!) {
        if (photo.photoUrl != null && photo.photoUrl!.isNotEmpty) {
          activityImages.add(photo.photoUrl!);
        }
      }
    }

    // If no images available, use placeholder
    if (activityImages.isEmpty) {
      activityImages.addAll([
        'https://picsum.photos/400/300',
        'https://picsum.photos/400/301',
        'https://picsum.photos/400/302',
      ]);
    }

    images.value = activityImages.toSet().toList(); // Remove duplicates
  }

  void updateCurrentImageIndex(int index) {
    currentImageIndex.value = index;
  }

  void onNavigateBack() {
    Get.back();
  }

  void openWebsite() async {
    final place = activity.value?.place;
    if (place == null) return;

    String? urlToOpen;

    if (place.website != null && place.website!.isNotEmpty) {
      urlToOpen = place.website!;
    } else if (place.webUrl != null && place.webUrl!.isNotEmpty) {
      urlToOpen = place.webUrl!;
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
    if (activity.value?.place == null) return 'Unknown Place';

    return Get.locale?.languageCode == 'vi'
        ? (activity.value!.place!.localName ??
            activity.value!.place!.name ??
            'Unknown Place')
        : (activity.value!.place!.name ?? 'Unknown Place');
  }

  String get placeDescription {
    final description = activity.value?.place?.description;
    if (description != null && description.isNotEmpty) {
      return description;
    }

    final placeType = activity.value?.place?.type;
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

  double get rating => activity.value?.place?.rating ?? 4.5;

  int get reviewCount => activity.value?.place?.numberReview ?? 0;

  void navigateToMap() {
    Get.toNamed(
      PageName.mapPage,
      arguments: {
        'activities': [activity.value],
        'dayNumber': dayNumber,
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
