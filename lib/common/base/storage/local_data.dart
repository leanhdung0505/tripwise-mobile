import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import '../../../data/model/user/user_model.dart';


class LocalData {
  static final shared = LocalData();

  final isFirstRunApp = ReadWriteValue(Keys.isFirstRun, true);
  final tokenData = ReadWriteValue(Keys.token, '');
  final refreshTokenData = ReadWriteValue(Keys.refreshToken, '');
  final userData = ReadWriteValue(Keys.user, '');

  bool? _isFirstRun;

  bool get isLogged =>
      GetStorage().hasData(Keys.token) && tokenData.val.isNotEmpty;

  UserModel? _user;

  UserModel? get user {
    final data = GetStorage().hasData(Keys.user);
    if (data) {
      final data = userData.val;
      _user = UserModel.fromJson(jsonDecode(data));
      return _user;
    } else {
      return null;
    }
  }

  set user(UserModel? newUser) {
    if (newUser != null) {
      _user = newUser;
      userData.val = jsonEncode(newUser.toJson());
    } else {
      _user = null;
      GetStorage().remove(Keys.user);
    }
  }

  Future<void> removeLocalData(String key) async {
    await GetStorage().remove(key);
  }

  Future<bool> isFirstRun() async {
    if (_isFirstRun != null) {
      return _isFirstRun!;
    } else {
      bool isFirstRun;
      try {
        isFirstRun = isFirstRunApp.val;
      } on Exception {
        isFirstRun = true;
      }
      isFirstRunApp.val = false;
      _isFirstRun ??= isFirstRun;
      return isFirstRun;
    }
  }
}

class Keys {
  static const isFirstRun = "isFirstRun";
  static const token = 'userToken';
  static const user = 'userData';
  static const refreshToken = 'refreshToken';
}
