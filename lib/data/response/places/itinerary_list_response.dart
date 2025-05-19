import 'package:trip_wise_app/data/response/places/pagination.dart';

import '../../model/itinerary/itinerary_model.dart';

class ItineraryListResponse {
  List<ItineraryModel>? itineraries;
  Pagination? pagination;

  ItineraryListResponse({
    this.itineraries,
    this.pagination,
  });

  ItineraryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      itineraries = <ItineraryModel>[];
      json['data'].forEach((v) {
        itineraries!.add(ItineraryModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    if (itineraries != null) {
      jsonData['data'] = itineraries!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      jsonData['pagination'] = pagination!.toJson();
    }
    return jsonData;
  }
}

