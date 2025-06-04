import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/app/app_bindings.dart';
import 'package:trip_wise_app/common/constants.dart';
import 'package:trip_wise_app/resource/lang/translate_service.dart';
import 'package:trip_wise_app/resource/theme/app_theme.dart';
import 'package:trip_wise_app/routes/app_routes.dart';
import 'package:trip_wise_app/services/fcm_service.dart';

Future<void> main() async {
  await init();
  runApp(const App());
  configLoading();
}

Future<void> init() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  await Get.putAsync<FCMService>(() async => FCMService());

  HttpOverrides.global = MyHttpOverrides();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorSize = 45.0
    ..boxShadow = [
      const BoxShadow(
        color: Colors.transparent,
      )
    ]
    ..radius = 10.0
    ..backgroundColor = Colors.transparent
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..maxConnectionsPerHost = 6
      ..connectionTimeout = const Duration(minutes: 1)
      ..idleTimeout = const Duration(minutes: 1)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 823),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: RebuildFactors.orientation,
      fontSizeResolver: FontSizeResolvers.height,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeftWithFade,
        getPages: AppPages.routes,
        initialBinding: AppBindings(),
        smartManagement: SmartManagement.keepFactory,
        title: Constants.appName,
        locale: TranslationService.locale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        fallbackLocale: TranslationService.fallbackLocale,
        translations: TranslationService(),
        builder: EasyLoading.init(),
        initialRoute: AppPages.initialRoute, // Use initialRoute from AppPages
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
      ),
    );
  }
}
