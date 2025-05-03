class LoginRequestModel {
  LoginRequestModel({
    this.password,
    this.email,
  });

  LoginRequestModel copyWith({
    String? password,
    String? email,
  }) {
    return LoginRequestModel(
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  LoginRequestModel.fromJson(dynamic json) {
    password = json['password'];
    email = json['email'];
  }

  String? password;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
