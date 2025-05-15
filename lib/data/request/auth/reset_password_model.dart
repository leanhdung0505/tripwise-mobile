class ResetPasswordModel {
  ResetPasswordModel({
    this.newPassword,
    this.email,
  });

  ResetPasswordModel copyWith({
    String? newPassword,
    String? email,
  }) {
    return ResetPasswordModel(
      newPassword: newPassword ?? this.newPassword,
      email: email ?? this.email,
    );
  }

  ResetPasswordModel.fromJson(dynamic json) {
    newPassword = json['new_password'];
    email = json['email'];
  }

  String? newPassword;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['new_password'] = newPassword;
    return map;
  }
}
