class PhotoModel {
  String? photoUrl;
  bool? isPrimary;
  int? photoId;
  int? placeId;
  String? createdAt;

  PhotoModel({
    this.photoUrl,
    this.isPrimary,
    this.photoId,
    this.placeId,
    this.createdAt,
  });

  PhotoModel.fromJson(Map<String, dynamic> json) {
    photoUrl = json['photo_url'];
    isPrimary = json['is_primary'];
    photoId = json['photo_id'];
    placeId = json['place_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo_url'] = photoUrl;
    data['is_primary'] = isPrimary;
    data['photo_id'] = photoId;
    data['place_id'] = placeId;
    data['created_at'] = createdAt;
    return data;
  }
}