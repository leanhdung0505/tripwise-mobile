class RestaurantDetailModel {
  List<String>? mealTypes;
  int? restaurantDetailId;
  int? placeId;
  String? createdAt;
  String? updatedAt;

  RestaurantDetailModel({
    this.mealTypes,
    this.restaurantDetailId,
    this.placeId,
    this.createdAt,
    this.updatedAt,
  });

  RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    mealTypes = json['meal_types'] != null
        ? List<String>.from(json['meal_types'])
        : null;
    restaurantDetailId = json['restaurant_detail_id'];
    placeId = json['place_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meal_types'] = mealTypes;
    data['restaurant_detail_id'] = restaurantDetailId;
    data['place_id'] = placeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  // Helper method to get formatted meal types string
  String get mealTypesString {
    if (mealTypes == null || mealTypes!.isEmpty) return '';
    return mealTypes!.join(', ');
  }
}