class LoginRequestModel {
  LoginRequestModel({
    this.password,
    this.email,
    this.fcmToken,
    this.device,
  });

  LoginRequestModel copyWith({
    String? password,
    String? email,
    String? fcmToken,
    String? device,
  }) {
    return LoginRequestModel(
      password: password ?? this.password,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      device: device ?? this.device,
    );
  }

  LoginRequestModel.fromJson(dynamic json) {
    password = json['password'];
    email = json['email'];
    fcmToken = json['fcm_token'];
    device = json['device'];
  }

  String? password;
  String? email;
  String? fcmToken;
  String? device;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    map['fcm_token'] = fcmToken;
    map['device'] = device;
    return map;
  }
}
