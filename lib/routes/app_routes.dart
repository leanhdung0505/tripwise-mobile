import 'package:get/get.dart';
import 'package:trip_wise_app/ui/auth/fogot-password/binding/forgot_password_binding.dart';
import 'package:trip_wise_app/ui/auth/fogot-password/screen/forgot_password_page.dart';
import 'package:trip_wise_app/ui/auth/login/binding/login_binding.dart';
import 'package:trip_wise_app/ui/auth/login/screen/login_page.dart';
import 'package:trip_wise_app/ui/auth/register/binding/register_binding.dart';
import 'package:trip_wise_app/ui/auth/register/screen/register_page.dart';
import 'package:trip_wise_app/ui/auth/request-otp/binding/request_otp_binding.dart';
import 'package:trip_wise_app/ui/auth/request-otp/screen/request_otp_page.dart';
import 'package:trip_wise_app/ui/auth/verify-code/binding/verify_code_binding.dart';
import 'package:trip_wise_app/ui/auth/verify-code/screen/verify_code_page.dart';
import 'package:trip_wise_app/ui/main/binding/main_binding.dart';
import 'package:trip_wise_app/ui/main/screen/main_page.dart';
import 'package:trip_wise_app/ui/splash/binding/splash_binding.dart';

import '../ui/auth/reset-password/binding/reset_password_binding.dart';
import '../ui/auth/reset-password/screen/reset_password_page.dart';
import '../ui/splash/screen/splash_page.dart';
import '../ui/success/binding/success_binding.dart';
import '../ui/success/screen/success_page.dart';

abstract class PageName {
  static const splashPage = '/';
  static const mainPage = '/main';
  static const loginPage = '/login';
  static const registerPage = '/register';
  static const forgotPasswordPage = '/forgot-password';
  static const resetPasswordPage = '/reset-password';
  static const verifyCodePage = '/verify-code';
  static const requestOtp = '/request-otp';
  static const successPage = '/success';
}

abstract class Argument {}

class AppPages {
  static const String initialRoute = PageName.splashPage; // Define initial route
  static final routes = [
    GetPage(
      name: PageName.splashPage,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: PageName.mainPage,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: PageName.loginPage,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: PageName.registerPage,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: PageName.forgotPasswordPage,
      page: () => const ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: PageName.resetPasswordPage,
      page: () => const ResetPasswordPage(),
      binding: ResetPasswordBinding(),
      transitionDuration: 500.milliseconds, 

    ),
    GetPage(
      name: PageName.verifyCodePage,
      page: () => const VerifyCodePage(),
      binding: VerifyCodeBinding(),
    ),
    GetPage(
      name: PageName.requestOtp,
      page: () => const RequestOtpPage(),
      binding: RequestOtpBinding(),
    ),
    GetPage(
      name: PageName.successPage,
      page: () => const SuccessPage(),
      binding: SuccessBinding(),
    ),
  ];
}
