import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/common/constants.dart';
import 'package:trip_wise_app/data/model/itinerary/activity_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../resource/theme/app_colors.dart';
import '../screen/widget/custom_marker_helper.dart';
import 'package:geolocator/geolocator.dart';

class MapController extends BaseController {
  static MapController get to => Get.find<MapController>();
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  Rxn<GoogleMapController> mapController = Rxn<GoogleMapController>();
  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  RxMap<PolylineId, Polyline> polylines = <PolylineId, Polyline>{}.obs;
  int? dayNumber;
  final Rx<CameraPosition> initialCameraPosition = const CameraPosition(
    target: LatLng(16.0544, 108.2022),
    zoom: 11,
  ).obs;

  final PolylinePoints polylinePoints = PolylinePoints();

  // PageView controller and current page index
  final PageController pageController = PageController();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final RxInt currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['activities'] != null && args['activities'] is List) {
        activities.value =
            (args['activities'] as List).whereType<ActivityModel>().toList();
      }
      if (args['dayNumber'] != null && args['dayNumber'] is int) {
        dayNumber = args['dayNumber'] as int;
      }
      if (activities.isNotEmpty) {
        _initializeMapData();
      }
    }
  }

  void _initializeMapData() {
    if (activities.first.place?.latitude != null &&
        activities.first.place?.longitude != null) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(
          activities.first.place!.latitude!,
          activities.first.place!.longitude!,
        ),
        zoom: 13,
      );
    }

    _createMarkers();
    _createPolylines();
  }

  void _createMarkers() async {
    for (int i = 0; i < activities.length; i++) {
      final activity = activities[i];
      if (activity.place?.latitude != null &&
          activity.place?.longitude != null) {
        BitmapDescriptor markerIcon;

        if (activity.place?.type?.toLowerCase() == 'attraction') {
          final markerBytes =
              await CustomMarkerHelper.createAttractionMarker('${i + 1}');
          markerIcon = BitmapDescriptor.bytes(markerBytes);
        } else if (activity.place?.type?.toLowerCase() == 'restaurant') {
          final markerBytes =
              await CustomMarkerHelper.createRestaurantMarker('${i + 1}');
          markerIcon = BitmapDescriptor.bytes(markerBytes);
        } else if (activity.place?.type?.toLowerCase() == 'hotel') {
          final hotelBytes =
              await CustomMarkerHelper.createHotelMarker('${i + 1}');
          markerIcon = BitmapDescriptor.bytes(hotelBytes);
        } else {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(i == 0
              ? BitmapDescriptor.hueGreen
              : i == activities.length - 1
                  ? BitmapDescriptor.hueRed
                  : BitmapDescriptor.hueAzure);
        }

        final markerId = MarkerId('marker_$i');
        final marker = Marker(
          markerId: markerId,
          position: LatLng(
            activity.place!.latitude!,
            activity.place!.longitude!,
          ),
          infoWindow: InfoWindow(
            title: activity.place?.name ?? 'Location ${i + 1}',
            snippet: activity.formattedStartTime,
          ),
          icon: markerIcon,
        );
        markers[markerId] = marker;
      }
    }
  }

  void _createPolylines() async {
    for (int i = 0; i < activities.length - 1; i++) {
      final startActivity = activities[i];
      final endActivity = activities[i + 1];

      if (startActivity.place?.latitude == null ||
          startActivity.place?.longitude == null ||
          endActivity.place?.latitude == null ||
          endActivity.place?.longitude == null) {
        continue;
      }

      try {
        final request = PolylineRequest(
          origin: PointLatLng(
              startActivity.place!.latitude!, startActivity.place!.longitude!),
          destination: PointLatLng(
              endActivity.place!.latitude!, endActivity.place!.longitude!),
          mode: TravelMode.driving,
        );

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          request: request,
          googleApiKey: Constants.googleMapsApiKey,
        );

        if (result.points.isNotEmpty) {
          List<LatLng> polylineCoordinates = [];

          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          PolylineId polylineId = PolylineId('polyline_$i');
          Polyline polyline = Polyline(
            polylineId: polylineId,
            color: Colors.blue,
            points: polylineCoordinates,
            width: 3,
          );
          polylines[polylineId] = polyline;
        } else {
          print('No polyline points returned: ${result.errorMessage}');
          _createDirectPolyline(i, startActivity, endActivity);
        }
      } catch (e) {
        print('Error getting polyline: $e');
        _createDirectPolyline(i, startActivity, endActivity);
      }
    }
  }

  void _createDirectPolyline(
      int index, ActivityModel startActivity, ActivityModel endActivity) {
    PolylineId polylineId = PolylineId('polyline_direct_$index');

    Polyline polyline = Polyline(
      polylineId: polylineId,
      color: AppColors.color0AA3E4.withOpacity(0.7),
      points: [
        LatLng(
          startActivity.place!.latitude!,
          startActivity.place!.longitude!,
        ),
        LatLng(
          endActivity.place!.latitude!,
          endActivity.place!.longitude!,
        ),
      ],
      width: 3,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );

    polylines[polylineId] = polyline;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }

  // Handle page change and zoom to location
  void onPageChanged(int index) {
    currentPageIndex.value = index;

    final activity = activities[index];
    if (activity.place?.latitude != null &&
        activity.place?.longitude != null &&
        mapController.value != null) {
      // Animate camera to the selected location
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            activity.place!.latitude!,
            activity.place!.longitude!,
          ),
          16, // Zoom level for individual location view
        ),
      );
    }
  }

  // Method to programmatically change page (if needed)
  void animateToPage(int index) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Method to fit all markers on the screen
  void fitAllMarkers() {
    if (markers.isEmpty || mapController.value == null) return;

    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;

    markers.forEach((_, marker) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng)
        minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng)
        maxLng = marker.position.longitude;
    });

    mapController.value!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - 0.01, minLng - 0.01),
          northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
        ),
        50,
      ),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    mapController.value?.dispose();
    super.onClose();
  }

  Future<void> moveToCurrentLocation() async {
    if (mapController.value == null) return;
    try {
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
      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      showCurrentLocationCircle(latLng);
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          16,
        ),
      );
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  final RxMap<CircleId, Circle> circles = <CircleId, Circle>{}.obs;

  void showCurrentLocationCircle(LatLng position) {
    final circleId = const CircleId('current_location');
    circles[circleId] = Circle(
      circleId: circleId,
      center: position,
      radius: 100, 
      fillColor: AppColors.color0AA3E4.withOpacity(0.3),
      strokeColor: AppColors.transparent,
      strokeWidth: 2,
    );
  }
}
