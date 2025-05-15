class RequestOtpModel {
  RequestOtpModel({
    this.purpose,
    this.email,
  });

  RequestOtpModel copyWith({
    String? purpose,
    String? email,
  }) {
    return RequestOtpModel(
      purpose: purpose ?? this.purpose,
      email: email ?? this.email,
    );
  }

  RequestOtpModel.fromJson(dynamic json) {
    purpose = json['purpose'];
    email = json['email'];
  }

  String? purpose;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['purpose'] = purpose;
    return map;
  }
}
