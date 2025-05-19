class UpdateTimeRequest {
  String? startTime;

  UpdateTimeRequest({
    this.startTime,
  });

  UpdateTimeRequest copyWith({
    String? startTime,
  }) {
    return UpdateTimeRequest(
      startTime: startTime ?? this.startTime,
    );
  }

  UpdateTimeRequest.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start_time'] = startTime;
    return map;
  }
}
