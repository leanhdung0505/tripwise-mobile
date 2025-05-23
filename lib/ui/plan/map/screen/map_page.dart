import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';
import '../../../../common/base/controller/base_page_widget.dart';
import '../../../../resource/theme/app_colors.dart';
import '../controller/map_controller.dart';

class MapPage extends BasePage<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.activities.isEmpty) {
          return const Center(
            child: Text('No activities found for this day'),
          );
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: controller.initialCameraPosition.value,
              markers: Set<Marker>.of(controller.markers.values),
              polylines: Set<Polyline>.of(controller.polylines.values),
              circles: Set<Circle>.of(controller.circles.values),
              onMapCreated: (GoogleMapController mapController) {
                controller.onMapCreated(mapController);
                Future.delayed(const Duration(milliseconds: 500), () {
                  controller.fitAllMarkers();
                });
              },
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
            ),
            Positioned(
              right: 20.w,
              bottom: 240.h,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.white,
                onPressed: controller.moveToCurrentLocation,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
            // Activity PageView at the bottom
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Page indicator dots
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.activities.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            width: controller.currentPageIndex.value == index
                                ? 20
                                : 8,
                            height: 8.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: CarouselSlider.builder(
                        carouselController: controller.carouselController,
                        itemCount: controller.activities.length,
                        options: CarouselOptions(
                          height: double.infinity,
                          viewportFraction: 0.75,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.15,
                          onPageChanged: (index, reason) {
                            controller.onPageChanged(index);
                          },
                          initialPage: controller.currentPageIndex.value,
                          padEnds: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (context, index, realIdx) {
                          final activity = controller.activities[index];
                          final bool isSelected =
                              controller.currentPageIndex.value == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: isSelected ? 5.h : 12.h),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.w,
                                      top: 16.h,
                                      bottom: 16.h,
                                      right: 6.w),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: const BoxDecoration(
                                          color: AppColors.color0AA3E4,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ),
                                      // Dash line
                                      Container(
                                        width: 2,
                                        height: 40.h,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4.h),
                                        child: CustomPaint(
                                          painter: _DashLinePainter(),
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns: -1,
                                        child: Text(
                                          'days'.trParams(
                                            {
                                              "day": controller.dayNumber
                                                  .toString(),
                                            },
                                          ),
                                          style: AppStyles.STYLE_14.copyWith(
                                              color: AppColors.color0C092A,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right card info
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w)
                                        .copyWith(top: 20.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.network(
                                                (activity.place?.photos
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? activity.place!.image
                                                        : 'https://via.placeholder.com/60') ??
                                                    'https://via.placeholder.com/60',
                                                width: 80.w,
                                                height: 80.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    activity.place?.name ?? '',
                                                    style: AppStyles
                                                        .STYLE_16_BOLD
                                                        .copyWith(
                                                            color: AppColors
                                                                .color0C092A),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Row(
                                                    children: List.generate(
                                                      5,
                                                      (star) => Icon(
                                                        Icons.star,
                                                        color: (activity.place
                                                                        ?.rating ??
                                                                    0) >
                                                                star
                                                            ? Colors.orange
                                                            : Colors.grey[300],
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 10.h),
                                        // Time
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time,
                                                color: AppColors.color0AA3E4,
                                                size: 18),
                                            SizedBox(width: 6.w),
                                            Text(
                                              activity.formattedStartTime,
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fit markers button
            Positioned(
              right: 20.w,
              top: 40.w,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.white,
                onPressed: controller.fitAllMarkers,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
                child: Icon(Icons.fullscreen,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            // Back button
            Positioned(
              left: 20.w,
              top: 40.w,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 44.w,
                  width: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Thêm painter cho dash line
class _DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.color7C8BA0.withOpacity(0.7)
      ..strokeWidth = 2;
    double dashHeight = 5, dashSpace = 4, startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
