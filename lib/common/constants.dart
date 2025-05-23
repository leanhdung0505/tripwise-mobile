import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String appName = 'Swii';
  static String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
