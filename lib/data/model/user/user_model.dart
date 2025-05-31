  class UserModel {
    UserModel({
      this.userId,
      this.username,
      this.email,
      this.password,
      this.fullName,
      this.role,
      this.profilePicture,
      this.preferences,
      this.budgetPreference,
      this.createdAt,
      this.updatedAt,
    });

    UserModel.fromJson(Map<String, dynamic> json) {
      userId = json['user_id'];
      username = json['username'];
      email = json['email'];
      password = json['password'];
      fullName = json['full_name'];
      profilePicture = json['profile_picture'];
      role = json['role'] ?? 'user';
      preferences = json['preferences'];
      budgetPreference = json['budget_preference'];
      createdAt =
          json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
      updatedAt =
          json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    }

    String? userId;
    String? username;
    String? email;
    String? password;
    String? fullName;
    String? profilePicture;
    String? role;
    Map<String, dynamic>? preferences;
    int? budgetPreference;
    DateTime? createdAt;
    DateTime? updatedAt;

    Map<String, dynamic> toJson() {
      final map = <String, dynamic>{};
      map['user_id'] = userId;
      map['username'] = username;
      map['email'] = email;
      map['password'] = password;
      map['full_name'] = fullName;
      map['role'] = role;
      map['profile_picture'] = profilePicture;
      map['preferences'] = preferences;
      map['budget_preference'] = budgetPreference;
      map['created_at'] = createdAt?.toIso8601String();
      map['updated_at'] = updatedAt?.toIso8601String();
      return map;
    }

    @override
    String toString() {
      return 'UserModel(userId: $userId, username: $username, email: $email, fullName: $fullName, role: $role, profilePicture: $profilePicture)';
    }
  }
