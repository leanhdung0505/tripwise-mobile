import 'activity_model.dart';

class DayModel {
  int? dayNumber;
  String? date;
  int? dayId;
  int? itineraryId;
  String? createdAt;
  String? updatedAt;
  List<ActivityModel>? activities;

  DayModel({
    this.dayNumber,
    this.date,
    this.dayId,
    this.itineraryId,
    this.createdAt,
    this.updatedAt,
    this.activities,
  });

  DayModel.fromJson(Map<String, dynamic> json) {
    dayNumber = json['day_number'];
    date = json['date'];
    dayId = json['day_id'];
    itineraryId = json['itinerary_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activities = json['activities'] != null
        ? (json['activities'] as List)
            .map((e) => ActivityModel.fromJson(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day_number'] = dayNumber;
    data['date'] = date;
    data['day_id'] = dayId;
    data['itinerary_id'] = itineraryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (activities != null) {
      data['activities'] = activities!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
