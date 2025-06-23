class CreateManualItineraryModel {
  CreateManualItineraryModel({
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.budgetCategory,
    this.destinationCity,
    this.hotelId,
  });

  CreateManualItineraryModel copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? budgetCategory,
    String? destinationCity,
    int? hotelId,
  }) {
    return CreateManualItineraryModel(
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budgetCategory: budgetCategory ?? this.budgetCategory,
      destinationCity: destinationCity ?? this.destinationCity,
      hotelId: hotelId ?? this.hotelId,
    );
  }

  CreateManualItineraryModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = DateTime.tryParse(json['start_date'] ?? '');
    endDate = DateTime.tryParse(json['end_date'] ?? '');
    budgetCategory = json['budget_category'];
    destinationCity = json['destination_city'];
    hotelId = json['hotel_id'];
  }

  String? title;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? budgetCategory;
  int? duration;
  String? destinationCity;
  int? hotelId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['start_date'] = startDate?.toIso8601String().split('T')[0];
    map['end_date'] = endDate?.toIso8601String().split('T')[0];
    map['budget_category'] = budgetCategory;
    map['destination_city'] = destinationCity;
    map['hotel_id'] = hotelId;
    return map;
  }
}
