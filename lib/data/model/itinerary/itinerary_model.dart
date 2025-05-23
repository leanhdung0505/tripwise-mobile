import 'dart:convert';

import 'day_model.dart';
import 'hotel_model.dart';

class ItineraryModel {
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? budget;
  String? destinationCity;
  bool? isFavorite;
  bool? isCompleted;
  int? hotelId;
  int? itineraryId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  HotelModel? hotel;
  List<DayModel>? days;

  ItineraryModel({
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.budget,
    this.destinationCity,
    this.isFavorite,
    this.isCompleted,
    this.hotelId,
    this.itineraryId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.hotel,
    this.days,
  });

  ItineraryModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    budget = json['budget'];
    destinationCity = json['destination_city'];
    isFavorite = json['is_favorite'];
    isCompleted = json['is_completed'];
    hotelId = json['hotel_id'];
    itineraryId = json['itinerary_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    hotel = json['hotel'] != null ? HotelModel.fromJson(json['hotel']) : null;
    days = json['days'] != null
        ? (json['days'] as List).map((e) => DayModel.fromJson(e)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['budget'] = budget;
    data['destination_city'] = destinationCity;
    data['is_favorite'] = isFavorite;
    data['is_completed'] = isCompleted;
    data['hotel_id'] = hotelId;
    data['itinerary_id'] = itineraryId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (hotel != null) {
      data['hotel'] = hotel?.toJson();
    }
    if (days != null) {
      data['days'] = days!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  static ItineraryModel fromJsonString(String jsonString) {
    return ItineraryModel.fromJson(json.decode(jsonString));
  }
}