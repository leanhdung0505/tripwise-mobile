import 'photo_model.dart';
import 'attraction_detail_model.dart';
import 'restaurant_detail_model.dart';

class PlaceModel {
  String? name;
  String? localName;
  String? description;
  String? type;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  double? rating;
  String? priceRange;
  String? phone;
  String? email;
  String? website;
  String? webUrl;
  String? image;
  int? placeId;
  String? createdAt;
  String? updatedAt;
  List<PhotoModel>? photos;
  int? numberReview;
  RestaurantDetailModel? restaurantDetail;
  AttractionDetailModel? attractionDetail;

  PlaceModel({
    this.name,
    this.localName,
    this.description,
    this.type,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.rating,
    this.priceRange,
    this.phone,
    this.email,
    this.website,
    this.webUrl,
    this.image,
    this.placeId,
    this.createdAt,
    this.updatedAt,
    this.photos,
    this.numberReview,
    this.restaurantDetail,
    this.attractionDetail,
  });

  PlaceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    localName = json['local_name'];
    description = json['description'];
    type = json['type'];
    address = json['address'];
    city = json['city'];
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    rating = json['rating']?.toDouble();
    priceRange = json['price_range'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    webUrl = json['web_url'];
    image = json['image'];
    placeId = json['place_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    photos = json['photos'] != null
        ? (json['photos'] as List).map((e) => PhotoModel.fromJson(e)).toList()
        : null;
    numberReview = json['number_review'];
    restaurantDetail = json['restaurant_detail'] != null
        ? RestaurantDetailModel.fromJson(json['restaurant_detail'])
        : null;
    attractionDetail = json['attraction_detail'] != null
        ? AttractionDetailModel.fromJson(json['attraction_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['local_name'] = localName;
    data['description'] = description;
    data['type'] = type;
    data['address'] = address;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['rating'] = rating;
    data['price_range'] = priceRange;
    data['phone'] = phone;
    data['email'] = email;
    data['website'] = website;
    data['web_url'] = webUrl;
    data['image'] = image;
    data['place_id'] = placeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (photos != null) {
      data['photos'] = photos!.map((e) => e.toJson()).toList();
    }
    data['number_review'] = numberReview;
    if (restaurantDetail != null) {
      data['restaurant_detail'] = restaurantDetail!.toJson();
    }
    if (attractionDetail != null) {
      data['attraction_detail'] = attractionDetail!.toJson();
    }
    return data;
  }

  // Helper methods
  bool get isRestaurant => type == 'RESTAURANT';
  bool get isAttraction => type == 'ATTRACTION';
  bool get isHotel => type == 'HOTEL';
}
