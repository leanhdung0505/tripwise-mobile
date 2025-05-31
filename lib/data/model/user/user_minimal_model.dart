class UserMinimalModel {
  UserMinimalModel({
    this.userId,
    this.username,
    this.email,
    this.fullName,
    this.profilePicture,
    this.permissions,
  });

  UserMinimalModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    fullName = json['full_name'];
    profilePicture = json['profile_picture'];
    permissions = json['permissions'];
  }

  String? userId;
  String? username;
  String? email;
  String? fullName;
  String? profilePicture;
  String? permissions;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['username'] = username;
    map['email'] = email;
    map['full_name'] = fullName;
    map['profile_picture'] = profilePicture;
    map['permissions'] = permissions;
    return map;
  }

  @override
  String toString() {
    return 'UserMinimalModel(userId: $userId, username: $username, email: $email, fullName: $fullName, profilePicture: $profilePicture, permissions: $permissions)';
  }
}
