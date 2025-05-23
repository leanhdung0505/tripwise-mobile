import 'place_model.dart';

class ActivityModel {
  int? placeId;
  String? startTime;
  int? itineraryActivityId;
  int? dayId;
  String? createdAt;
  String? updatedAt;
  PlaceModel? place;

  ActivityModel({
    this.placeId,
    this.startTime,
    this.itineraryActivityId,
    this.dayId,
    this.createdAt,
    this.updatedAt,
    this.place,
  });

  ActivityModel.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    startTime = json['start_time'];
    itineraryActivityId = json['itinerary_activity_id'];
    dayId = json['day_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    place = json['place'] != null ? PlaceModel.fromJson(json['place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_id'] = placeId;
    data['start_time'] = startTime;
    data['itinerary_activity_id'] = itineraryActivityId;
    data['day_id'] = dayId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (place != null) {
      data['place'] = place!.toJson();
    }
    return data;
  }

  String get formattedStartTime {
    try {
      final parts = startTime?.split(':') ?? [];
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$displayHour:$minute $period';
      }
    } catch (_) {}
    return startTime ?? '';
  }
}