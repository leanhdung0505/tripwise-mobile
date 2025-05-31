import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../data/model/itinerary/hotel_model.dart';
import '../../../../../data/model/itinerary/activity_model.dart';
import '../../../../../data/model/itinerary/place_model.dart';
import '../../../../../resource/asset/app_images.dart';
import '../../../../../resource/theme/app_colors.dart';
import '../../../../../resource/theme/app_style.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../controller/itinerary_controller.dart';

class HotelItemWidget extends StatefulWidget {
  final HotelModel? hotel;

  const HotelItemWidget({
    super.key,
    required this.hotel,
  });

  @override
  State<HotelItemWidget> createState() => _HotelItemWidgetState();
}

class _HotelItemWidgetState extends State<HotelItemWidget> {
  int _currentIndex = 0;
  final ItineraryController itineraryController = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<String> images = [];

    // Add main image if exists
    if (widget.hotel?.image != null && widget.hotel!.image!.isNotEmpty) {
      images.add(widget.hotel!.image!);
    }

    // Add photos if exist
    if (widget.hotel?.photos != null) {
      images.addAll(widget.hotel!.photos!
          .where((photo) => photo.photoUrl != null)
          .map((photo) => photo.photoUrl!));
    }

    // Add fallback images if no images available
    if (images.isEmpty) {
      images.addAll([
        'https://picsum.photos/400/300',
        'https://picsum.photos/400/301',
      ]);
    }

    final String hotelName = Get.locale?.languageCode == 'vi'
        ? (widget.hotel?.localName ?? "Khách sạn")
        : (widget.hotel?.name ?? 'Hotel');

    final double rating = widget.hotel?.rating ?? 4.5;
    final int numberReview = widget.hotel?.numberReview ?? 0;

    return InkWell(
      onTap: _navigateToHotelDetail,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
        ).copyWith(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  const Icon(
                    Icons.hotel,
                    color: AppColors.color3461FD,
                    size: 24,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'hotel'.tr,
                    style: AppStyles.STYLE_14.copyWith(
                      color: AppColors.color0C092A,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) => Image.network(
                          images[index],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: AppColors.color3461FD,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Indicator
                    Positioned(
                      bottom: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentIndex == index ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? AppColors.color3461FD
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 20.h),
              child: Text(
                hotelName,
                style: AppStyles.STYLE_16_BOLD.copyWith(
                  color: AppColors.color0C092A,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h).copyWith(
                bottom: 16.h,
                top: 8.h,
              ),
              child: Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < rating.floor()
                            ? Colors.amber
                            : Colors.grey[300],
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'reviews'.trParams(
                      {"review": numberReview.toString()},
                    ),
                    style: AppStyles.STYLE_12.copyWith(
                      color: AppColors.color0C092A,
                    ),
                  ),
                  const Spacer(),
                  if (widget.hotel?.webUrl != null)
                    InkWell(
                      onTap: _navigateToMap,
                      child: SvgPicture.asset(
                        AppImages.icMapOutline,
                        height: 35.h,
                        width: 35.w,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMap() async {
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
    if (widget.hotel != null) {
      final activityModel = ActivityModel(
        itineraryActivityId: 0,
        dayId: 0,
        placeId: widget.hotel!.placeId,
        startTime: DateTime.now().toIso8601String(),
        place: PlaceModel(
          placeId: widget.hotel!.placeId,
          name: widget.hotel!.name,
          localName: widget.hotel!.localName,
          description: widget.hotel!.description,
          type: widget.hotel!.type,
          address: widget.hotel!.address,
          city: widget.hotel!.city,
          latitude: widget.hotel!.latitude,
          longitude: widget.hotel!.longitude,
          rating: widget.hotel!.rating,
          priceRange: widget.hotel!.priceRange,
          phone: widget.hotel!.phone,
          email: widget.hotel!.email,
          website: widget.hotel!.website,
          webUrl: widget.hotel!.webUrl,
          image: widget.hotel!.image,
          photos: widget.hotel!.photos,
          numberReview: widget.hotel!.numberReview,
        ),
      );

      Get.toNamed(
        PageName.mapPage,
        arguments: {
          'showRoute': true,
          'startLat': position.latitude,
          'startLng': position.longitude,
          'endLat': widget.hotel!.latitude,
          'endLng': widget.hotel!.longitude,
          'activityIndex': 0,
          'activities': [activityModel],
          'showCurrentLocation': true,
          'dayNumber': 0,
        },
      );
    }
  }

  void _navigateToHotelDetail() {
    if (widget.hotel != null) {
      final placeModel = PlaceModel(
        placeId: widget.hotel!.placeId,
        name: widget.hotel!.name,
        localName: widget.hotel!.localName,
        description: widget.hotel!.description,
        type: widget.hotel!.type,
        address: widget.hotel!.address,
        city: widget.hotel!.city,
        latitude: widget.hotel!.latitude,
        longitude: widget.hotel!.longitude,
        rating: widget.hotel!.rating,
        priceRange: widget.hotel!.priceRange,
        phone: widget.hotel!.phone,
        email: widget.hotel!.email,
        website: widget.hotel!.website,
        webUrl: widget.hotel!.webUrl,
        image: widget.hotel!.image,
        photos: widget.hotel!.photos,
        numberReview: widget.hotel!.numberReview,
      );

      Get.toNamed(
        PageName.activityDetailPage,
        arguments: {
          'place': placeModel,
          'dayNumber': 0,
          'itineraryId': itineraryController.itineraryId,
          'dayId': itineraryController
              .days[itineraryController.selectedDayIndex.value].dayId,
        },
      );
    }
  }
}
