import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class DistanceUtils {
  static double calculateDistance(
    double? lat1,
    double? lon1,
    double? lat2,
    double? lon2,
  ) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return 0.0;
    }
    const double radius = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    final double c = 2 * asin(sqrt(a));
    return radius * c;
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      final int meters = (distanceInKm * 1000).round();
      return '$meters m';
    } else {  
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }
}
