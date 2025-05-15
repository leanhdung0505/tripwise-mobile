class RegisterRequestModel {
  RegisterRequestModel({
    this.username,
    this.fullName,
    this.role,
    this.password,
    this.email,
  });

  RegisterRequestModel copyWith({
    String? username,
    String? fullName,
    String? role,
    String? password,
    String? email,
  }) {
    return RegisterRequestModel(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }

  RegisterRequestModel.fromJson(dynamic json) {
    username = json['username'];
    fullName = json['full_name'];
    role = json['role'];
    password = json['password'];
    email = json['email'];
  }

  String? username;
  String? fullName;
  String? role;
  String? password;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['full_name'] = fullName;
    map['role'] = role;
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
