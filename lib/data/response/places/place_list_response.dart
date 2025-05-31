import 'package:trip_wise_app/data/model/itinerary/place_model.dart';
import 'package:trip_wise_app/data/response/places/pagination.dart';

class PlaceListResponse {
  List<PlaceModel>? places;
  Pagination? pagination;

  PlaceListResponse({
    this.places,
    this.pagination,
  });

  PlaceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      places = <PlaceModel>[];
      json['data'].forEach((v) {
        places!.add(PlaceModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (places != null) {
      data['data'] = places!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}
