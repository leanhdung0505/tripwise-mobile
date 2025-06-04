import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/routes/app_routes.dart';

class FCMService extends GetxService {
  static FCMService get to => Get.find<FCMService>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
 
  String? _fcmToken;
  String? _deviceName;

  String? get fcmToken => _fcmToken;
  String? get deviceName => _deviceName;

  @override
  void onInit() {
    super.onInit();
    _initFCM();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        _deviceName = iosInfo.name; 
      }
    } catch (e) {
      print('Error getting device info: $e');
      _deviceName = 'Unknown Device';
    }
  }

  Future<Map<String, String?>> getDeviceInfo() async {
    if (_fcmToken == null) {
      _fcmToken = await _firebaseMessaging.getToken();
    }
    if (_deviceName == null) {
      await _getDeviceInfo();
    }

    return {
      'fcm_token': _fcmToken,
      'device_name': _deviceName,
    };
  }

  Future<void> _initFCM() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    _fcmToken = await _firebaseMessaging.getToken();
    if (_fcmToken != null) {
      print('FCM Token: $_fcmToken');
    }

    _firebaseMessaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      print('FCM Token refreshed: $token');
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      await _showLocalNotification(message);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'trip_wise_channel',
      'Trip Wise Notifications',
      channelDescription: 'Notifications from Trip Wise app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Thông báo mới',
      message.notification?.body ?? '',
      details,
      payload: message.data['itinerary_id']?.toString(),
    );
  }

  void _onSelectNotification(NotificationResponse response) {
    if (response.payload != null) {
      final itineraryId = response.payload;
      Get.toNamed(
        PageName.itineraryPage,
        arguments: {'itineraryId': int.parse(itineraryId!)},
      );
    }
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    if (message.data['itinerary_id'] != null) {
      final itineraryId = message.data['itinerary_id'];
      Get.toNamed(
        PageName.itineraryPage,
        arguments: {'itineraryId': int.parse(itineraryId!)},
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
  print('Background Message data: ${message.data}');
  print('Background Notification: ${message.notification?.title}');
}
