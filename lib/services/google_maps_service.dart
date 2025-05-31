import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:trip_wise_app/common/base/api/api_service.dart';
import '../common/constants.dart';

class GoogleMapsService {
  static final String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json";
  static final String _apiKey = Constants.googleMapsDirectionApiKey;
  static final ApiService _apiService = ApiService();

  static Future<Map<String, dynamic>> getDirections({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final response = await _apiService.getUriData(
        url:
            '$_baseUrl?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$_apiKey',
        header: {
          'Accept': 'application/json',
        },
      );

      final data = response.body;
      if (data != null && data['status'] == 'OK') {
        // Decode polylines
        final points = PolylinePoints().decodePolyline(
          data['routes'][0]['overview_polyline']['points'],
        );

        // Convert to LatLng list
        final List<LatLng> polylineCoordinates = points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Calculate total distance and duration
        final legs = data['routes'][0]['legs'][0];
        final distance = legs['distance']['text'];
        final duration = legs['duration']['text'];

        return {
          'polylineCoordinates': polylineCoordinates,
          'distance': distance,
          'duration': duration,
        };
      }
      throw Exception('Failed to get directions: Invalid response');
    } catch (e) {
      throw Exception('Failed to get directions: $e');
    }
  }

  // Thêm phương thức để lấy thông tin về các điểm dừng chân trên đường đi
  static Future<Map<String, dynamic>> getDirectionsWithWaypoints({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required List<LatLng> waypoints,
  }) async {
    try {
      // Tạo chuỗi waypoints
      final String waypointsString = waypoints
          .map((point) => '${point.latitude},${point.longitude}')
          .join('|');

      final response = await _apiService.getUriData(
        url: '$_baseUrl?origin=$startLat,$startLng'
            '&destination=$endLat,$endLng'
            '&waypoints=optimize:true|$waypointsString'
            '&key=$_apiKey',
        header: {
          'Accept': 'application/json',
        },
      );

      final data = response.body;
      if (data != null && data['status'] == 'OK') {
        // Decode polylines
        final points = PolylinePoints().decodePolyline(
          data['routes'][0]['overview_polyline']['points'],
        );

        // Convert to LatLng list
        final List<LatLng> polylineCoordinates = points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Get waypoint order
        final List<int> waypointOrder =
            List<int>.from(data['routes'][0]['waypoint_order']);

        // Calculate total distance and duration
        final legs = data['routes'][0]['legs'];
        double totalDistance = 0;
        double totalDuration = 0;
        final List<Map<String, dynamic>> legInfo = [];

        for (var leg in legs) {
          totalDistance += leg['distance']['value'] / 1000; // Convert to km
          totalDuration += leg['duration']['value'] / 60; // Convert to minutes
          legInfo.add({
            'distance': leg['distance']['text'],
            'duration': leg['duration']['text'],
            'start_address': leg['start_address'],
            'end_address': leg['end_address'],
          });
        }

        return {
          'polylineCoordinates': polylineCoordinates,
          'waypoint_order': waypointOrder,
          'total_distance': '${totalDistance.toStringAsFixed(1)} km',
          'total_duration': '${totalDuration.toStringAsFixed(0)} mins',
          'legs': legInfo,
        };
      }
      throw Exception(
          'Failed to get directions with waypoints: Invalid response');
    } catch (e) {
      throw Exception('Failed to get directions with waypoints: $e');
    }
  }
}
