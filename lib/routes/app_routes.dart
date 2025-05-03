import 'package:get/get.dart';
import 'package:trip_wise_app/ui/login/binding/login_binding.dart';
import 'package:trip_wise_app/ui/login/screen/login_page.dart';
import 'package:trip_wise_app/ui/main/binding/main_binding.dart';
import 'package:trip_wise_app/ui/main/screen/main_page.dart';
import 'package:trip_wise_app/ui/splash/binding/splash_binding.dart';

import '../ui/splash/screen/splash_page.dart';

abstract class PageName {
  static const splashPage = '/';
  static const mainPage = '/main';
  static const loginPage = '/login';
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
  ];
}
