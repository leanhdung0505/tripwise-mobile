class AttractionDetailModel {
  Map<String, String>? subcategory;
  Map<String, String>? subtype;
  int? attractionDetailId;
  int? placeId;
  String? createdAt;
  String? updatedAt;

  AttractionDetailModel({
    this.subcategory,
    this.subtype,
    this.attractionDetailId,
    this.placeId,
    this.createdAt,
    this.updatedAt,
  });

  AttractionDetailModel.fromJson(Map<String, dynamic> json) {
    subcategory = json['subcategory'] != null
        ? Map<String, String>.from(json['subcategory'])
        : null;
    subtype = json['subtype'] != null
        ? Map<String, String>.from(json['subtype'])
        : null;
    attractionDetailId = json['attraction_detail_id'];
    placeId = json['place_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcategory'] = subcategory;
    data['subtype'] = subtype;
    data['attraction_detail_id'] = attractionDetailId;
    data['place_id'] = placeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  // Helper methods to get formatted strings
  String get subcategoriesString {
    if (subcategory == null || subcategory!.isEmpty) return '';
    return subcategory!.values.join(', ');
  }

  String get subtypesString {
    if (subtype == null || subtype!.isEmpty) return '';
    return subtype!.values.join(', ');
  }
}