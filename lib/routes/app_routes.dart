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
import 'package:trip_wise_app/ui/data-entry/budget/binding/budget_binding.dart';
import 'package:trip_wise_app/ui/data-entry/budget/screen/budget_page.dart';
import 'package:trip_wise_app/ui/data-entry/calendar/binding/calendar_binding.dart';
import 'package:trip_wise_app/ui/data-entry/calendar/screen/calendar_page.dart';
import 'package:trip_wise_app/ui/data-entry/interests/binding/interests_binding.dart';
import 'package:trip_wise_app/ui/data-entry/interests/screen/interests_page.dart';
import 'package:trip_wise_app/ui/plan/activity_detail/binding/activity_detail_binding.dart';
import 'package:trip_wise_app/ui/plan/activity_detail/screen/activity_detail_page.dart';
import 'package:trip_wise_app/ui/plan/itinerary/binding/itinerary_binding.dart';
import 'package:trip_wise_app/ui/plan/itinerary/screen/itinerary_page.dart';
import 'package:trip_wise_app/ui/main/binding/main_binding.dart';
import 'package:trip_wise_app/ui/main/screen/main_page.dart';
import 'package:trip_wise_app/ui/plan/search_places/binding/search_places_binding.dart';
import 'package:trip_wise_app/ui/plan/search_places/screen/search_places_page.dart';
import 'package:trip_wise_app/ui/splash/binding/splash_binding.dart';

import '../ui/auth/reset-password/binding/reset_password_binding.dart';
import '../ui/auth/reset-password/screen/reset_password_page.dart';
import '../ui/data-entry/duration/binding/duration_binding.dart';
import '../ui/data-entry/duration/screen/duration_page.dart';
import '../ui/data-entry/process_loading/binding/process_loading.dart';
import '../ui/data-entry/process_loading/screen/process_loading_page.dart';
import '../ui/favorite/screen/favorite_page.dart';
import '../ui/favorite/binding/favorite_binding.dart';
import '../ui/home/binding/home_binding.dart';
import '../ui/home/screen/home_page.dart';
import '../ui/personal/setting/binding/setting_binding.dart';
import '../ui/personal/setting/screen/setting_page.dart';
import '../ui/plan/map/binding/map_binding.dart';
import '../ui/plan/map/screen/map_page.dart';
import '../ui/personal/profile/binding/profile_binding.dart';
import '../ui/personal/profile/screen/profile_page.dart';
import '../ui/share/binding/share_binding.dart';
import '../ui/share/screen/share_page.dart';
import '../ui/splash/screen/splash_page.dart';
import '../ui/success/binding/success_binding.dart';
import '../ui/success/screen/success_page.dart';
import '../ui/personal/change_password/binding/change_password_binding.dart';
import '../ui/personal/change_password/screen/change_password_page.dart';

abstract class PageName {
  static const splashPage = '/';
  static const mainPage = '/main';
  static const loginPage = '/login';
  static const homePage = '/home';
  static const registerPage = '/register';
  static const forgotPasswordPage = '/forgot-password';
  static const resetPasswordPage = '/reset-password';
  static const verifyCodePage = '/verify-code';
  static const requestOtp = '/request-otp';
  static const successPage = '/success';
  static const durationPage = '/duration-page';
  static const calendarPage = '/calendar-page';
  static const interestsPage = '/interest-page';
  static const budgetPage = '/budget-page';
  static const itineraryPage = '/itinerary-page';
  static const mapPage = '/map-page';
  static const activityDetailPage = '/activity-detail-page';
  static const searchPlacesPage = '/search-places-page';
  static const profilePage = '/profile-page';
  static const favoritePage = '/favorite-page';
  static const sharePage = '/share-page';
  static const processLoadingPage = '/process-loading-page';
  static const settingPage = '/setting-page';
  static const changePasswordPage = '/change-password';
}

abstract class Argument {}

class AppPages {
  static const String initialRoute =
      PageName.splashPage; // Define initial route
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
      name: PageName.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
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
    GetPage(
      name: PageName.durationPage,
      page: () => const DurationPage(),
      binding: DurationBinding(),
      transitionDuration: 100.milliseconds,
    ),
    GetPage(
      name: PageName.calendarPage,
      page: () => const CalendarPage(),
      binding: CalendarBinding(),
      transitionDuration: 100.milliseconds,
    ),
    GetPage(
      name: PageName.interestsPage,
      page: () => const InterestsPage(),
      binding: InterestsBinding(),
      transitionDuration: 100.milliseconds,
    ),
    GetPage(
      name: PageName.budgetPage,
      page: () => const BudgetPage(),
      binding: BudgetBinding(),
      transitionDuration: 100.milliseconds,
    ),
    GetPage(
      name: PageName.itineraryPage,
      page: () => const ItineraryPage(),
      binding: ItineraryBinding(),
    ),
    GetPage(
      name: PageName.mapPage,
      page: () => const MapPage(),
      binding: MapBinding(),
    ),
    GetPage(
      name: PageName.activityDetailPage,
      page: () => const ActivityDetailPage(),
      binding: ActivityDetailBinding(),
    ),
    GetPage(
      name: PageName.searchPlacesPage,
      page: () => const SearchPlacesPage(),
      binding: SearchPlacesBinding(),
    ),
    GetPage(
      name: PageName.profilePage,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: PageName.favoritePage,
      page: () => const FavoritePage(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: PageName.sharePage,
      page: () => const SharePage(),
      binding: ShareBinding(),
    ),
    GetPage(
      name: PageName.processLoadingPage,
      page: () => const ProcessLoadingPage(),
      binding: ProcessLoadingBinding(),
    ),
    GetPage(
      name: PageName.settingPage,
      page: () => const SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: PageName.changePasswordPage,
      page: () => const ChangePasswordPage(),
      binding: ChangePasswordBinding(),
    ),
  ];
}
