import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../common/base/controller/base_controller.dart';
import '../../../../common/repository/auth_repository.dart';
import '../../../../services/fcm_service.dart';

import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/base/storage/local_data.dart';
import '../../../../common/repository/user_repository.dart';
import '../../../../common/repository/user_repository_impl.dart';
import '../../../../data/model/user/user_model.dart';
import '../../../../data/request/auth/login_request_model.dart';
import '../../../../data/response/auth_response.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_validator.dart';

class LoginController extends BaseController {
  static LoginController get to => Get.find<LoginController>();

  AuthRepository repository = Get.find();
  final AuthRepository _authRepository = Get.find();
  final UserRepository _userRepository = UserRepositoryImpl();
  final FCMService _fcmService = Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isChecked = false.obs;
  Rx<bool> isLoginButtonEnabled = false.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isGoogleLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
  }

  void onNavigateMainPage() {
    if (formKey.currentState?.validate() == false) return;
    Get.offAllNamed(PageName.mainPage);
  }

  void onNavigateForgotPasswordPage() {
    Get.toNamed(PageName.forgotPasswordPage);
  }

  void onTextChanged(String? value) {
    checkButtonStatus();
  }

  void checkButtonStatus() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoginButtonEnabled.value = AppValidator.validateEmail(email) == null &&
        AppValidator.validatePassword(password) == null;
  }

  Future<void> onLogin() async {
    if (isLoginButtonEnabled.value) {
      isLoading.value = true;
      final deviceInfo = await _fcmService.getDeviceInfo();
      final request = LoginRequestModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        fcmToken: deviceInfo['fcm_token'],
        device: deviceInfo['device_name'],
      );
      subscribe(
        future: _authRepository.login(
          body: request.toJson(),
        ),
        observer: ObserverFunc(
          onSubscribe: () {},
          onSuccess: (response) {
            final authResponse = AuthResponse.fromJson(response.body['data']);
            LocalData.shared.tokenData.val = authResponse.accessToken;
            LocalData.shared.refreshTokenData.val = authResponse.refreshToken;
            showSimpleSuccessSnackBar(message: "loginSuccess".tr);
            saveUser();
            navigateMain();
          },
          onError: (error) {
            showSimpleErrorSnackBar(message: error.message ?? "");
          },
        ),
        isShowLoading: false,
      ).whenComplete(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> onGoogleSignIn() async {
    isGoogleLoading.value = true;
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
        'https://www.googleapis.com/auth/userinfo.email',
      ],
    );

    await _googleSignIn.signOut();
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) return;
    final GoogleSignInAuthentication auth = await account.authentication;
    final String? accessToken = auth.accessToken;
    final deviceInfo = await _fcmService.getDeviceInfo();

    subscribe(
      future: _authRepository.googleSignIn(
        body: {
          'token': accessToken,
          'fcm_token': deviceInfo['fcm_token'],
          'device': deviceInfo['device_name'],
        },
      ),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final authResponse = AuthResponse.fromJson(response.body['data']);
          LocalData.shared.tokenData.val = authResponse.accessToken;
          LocalData.shared.refreshTokenData.val = authResponse.refreshToken;
          showSimpleSuccessSnackBar(message: "loginSuccess".tr);
          isChecked.value = true;
          saveUser();
          navigateMain();
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
          isGoogleLoading.value = false;
        },
      ),
      isShowLoading: true,
    );
  }

  Future<void> saveUser() async {
    subscribe(
      future: _userRepository.getUser(),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final user = UserModel.fromJson(response.body['data']);
          LocalData.shared.user = user;
        },
        onError: (error) {
          showSimpleErrorSnackBar(message: error.message ?? "");
        },
      ),
    );
  }

  void navigateMain() {
    if (isLoginButtonEnabled.value || isChecked.value == true) {
      Get.toNamed(PageName.mainPage);
    }
  }

  void onNavigateRegisterPage() {
    Get.toNamed(PageName.requestOtp);
  }

  void changeLanguage(String languageCode) {
    Locale locale = Locale(languageCode);
    Get.updateLocale(locale);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
