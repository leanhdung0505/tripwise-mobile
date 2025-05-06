class VerifyOtpModel {
  VerifyOtpModel({
    this.token,
    this.otpCode,
  });

  VerifyOtpModel copyWith({
    String? token,
    String? otpCode,
  }) {
    return VerifyOtpModel(
      token: token ?? this.token,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  VerifyOtpModel.fromJson(dynamic json) {
    token = json['token'];
    otpCode = json['otp_code'];
  }

  String? token;
  String? otpCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otp_code'] = otpCode;
    map['token'] = token;
    return map;
  }
}
