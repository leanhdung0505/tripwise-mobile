import 'package:get/get.dart';

class ActivityModel {
  RxString id = ''.obs;
  RxString locationName = ''.obs;
  RxInt day = 1.obs;
  RxInt activityNumber = 0.obs;
  RxList<String> images = <String>[].obs;
  RxString startTime = ''.obs;

  ActivityModel({
    required String id,
    required String locationName,
    required int day,
    required int activityNumber,
    required List<String> images,
    required String startTime,
  }) {
    this.id.value = id;
    this.locationName.value = locationName;
    this.day.value = day;
    this.activityNumber.value = activityNumber;
    this.images.value = images;
    this.startTime.value = startTime;
  }
}