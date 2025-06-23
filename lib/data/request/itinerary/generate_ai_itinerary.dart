class Activity {
  Activity({
    this.placeId,
  });

  Activity copyWith({
    int? placeId,
  }) {
    return Activity(
      placeId: placeId ?? this.placeId,
    );
  }

  Activity.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
  }

  int? placeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['place_id'] = placeId;
    return map;
  }
}

class Day {
  Day({
    this.dayNumber,
    this.activities,
  });

  Day copyWith({
    int? dayNumber,
    List<Activity>? activities,
  }) {
    return Day(
      dayNumber: dayNumber ?? this.dayNumber,
      activities: activities ?? this.activities,
    );
  }

  Day.fromJson(Map<String, dynamic> json) {
    dayNumber = json['day_number'];
    activities = (json['activities'] as List<dynamic>?)
        ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  int? dayNumber;
  List<Activity>? activities;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day_number'] = dayNumber;
    if (activities != null) {
      map['activities'] = activities!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class GenerateAiItineraryModel {
  GenerateAiItineraryModel({
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.budgetCategory,
    this.duration,
    this.destinationCity,
    this.hotelId,
    this.days,
  });

  GenerateAiItineraryModel copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? budgetCategory,
    int? duration,
    String? destinationCity,
    int? hotelId,
    List<Day>? days,
  }) {
    return GenerateAiItineraryModel(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budgetCategory: budgetCategory ?? this.budgetCategory,
      duration: duration ?? this.duration,
      destinationCity: destinationCity ?? this.destinationCity,
      hotelId: hotelId ?? this.hotelId,
      days: days ?? this.days,
    );
  }

  GenerateAiItineraryModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = DateTime.tryParse(json['start_date'] ?? '');
    endDate = DateTime.tryParse(json['end_date'] ?? '');
    budgetCategory = json['budget_category'];
    duration = json['duration'];
    destinationCity = json['destination_city'];
    hotelId = json['hotel_id'];
    days = (json['days'] as List<dynamic>?)
        ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? budgetCategory;
  int? duration;
  String? destinationCity;
  int? hotelId;
  List<Day>? days;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['start_date'] = startDate?.toIso8601String().split('T')[0];
    map['end_date'] = endDate?.toIso8601String().split('T')[0];
    map['budget_category'] = budgetCategory;
    map['duration'] = duration;
    map['destination_city'] = destinationCity;
    map['hotel_id'] = hotelId;
    if (days != null) {
      map['days'] = days!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
