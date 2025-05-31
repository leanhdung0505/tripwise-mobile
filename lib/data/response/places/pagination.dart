class Pagination {
  int? page;
  int? totalPages;
  int? limit;
  bool? hasPrev;
  bool? hasNext;

  Pagination({
    this.page,
    this.totalPages,
    this.limit,
    this.hasPrev,
    this.hasNext,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalPages = json['total_pages'];
    limit = json['limit'];
    hasPrev = json['has_prev'];
    hasNext = json['has_next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['total_pages'] = totalPages;
    data['limit'] = limit;
    data['has_prev'] = hasPrev;
    data['has_next'] = hasNext;
    return data;
  }
}