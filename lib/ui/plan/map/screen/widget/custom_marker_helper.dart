import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:trip_wise_app/resource/theme/app_colors.dart';
import 'package:trip_wise_app/resource/theme/app_style.dart';

class CustomMarkerHelper {
  static Future<Uint8List> createAttractionMarker(
    String text, {
    double size = 70,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final path = Path();
    path.moveTo(size / 2, size * 0.9);
    path.quadraticBezierTo(size * 0.2, size * 0.6, size * 0.2, size * 0.4);
    path.quadraticBezierTo(size * 0.2, size * 0.1, size / 2, size * 0.1);
    path.quadraticBezierTo(size * 0.8, size * 0.1, size * 0.8, size * 0.4);
    path.quadraticBezierTo(size * 0.8, size * 0.6, size / 2, size * 0.9);
    path.close();

    final paint = Paint()
      ..color = AppColors.color4285F4
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppStyles.STYLE_18_BOLD.copyWith(
          color: AppColors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      (size - textPainter.width) / 2,
      (size - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);

    final circleCenter = Offset(size * 0.7, size * 0.22);
    final circleRadius = size * 0.1;
    final circlePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.attractions.codePoint),
        style: TextStyle(
          fontSize: circleRadius * 2,
          fontFamily: Icons.attractions.fontFamily,
          package: Icons.attractions.fontPackage,
          color: AppColors.color4285F4,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    final iconOffset = Offset(
      circleCenter.dx - iconPainter.width / 2,
      circleCenter.dy - iconPainter.height / 2,
    );
    iconPainter.paint(canvas, iconOffset);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static Future<Uint8List> createRestaurantMarker(
    String text, {
    double size = 70,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final path = Path();
    path.moveTo(size / 2, size * 0.9);
    path.quadraticBezierTo(size * 0.2, size * 0.6, size * 0.2, size * 0.4);
    path.quadraticBezierTo(size * 0.2, size * 0.1, size / 2, size * 0.1);
    path.quadraticBezierTo(size * 0.8, size * 0.1, size * 0.8, size * 0.4);
    path.quadraticBezierTo(size * 0.8, size * 0.6, size / 2, size * 0.9);
    path.close();

    final paint = Paint()
      ..color = AppColors.colorFF8C00
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(path, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppStyles.STYLE_18_BOLD.copyWith(
          color: AppColors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      (size - textPainter.width) / 2,
      (size - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);

    final circleCenter = Offset(size * 0.7, size * 0.22);
    final circleRadius = size * 0.1;
    final circlePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.restaurant.codePoint),
        style: TextStyle(
          fontSize: circleRadius * 2,
          fontFamily: Icons.restaurant.fontFamily,
          package: Icons.restaurant.fontPackage,
          color: AppColors.colorFF8C00,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    final iconOffset = Offset(
      circleCenter.dx - iconPainter.width / 2,
      circleCenter.dy - iconPainter.height / 2,
    );
    iconPainter.paint(canvas, iconOffset);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  static Future<Uint8List> createHotelMarker(
    String text, {
    double size = 70,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final path = Path();
    path.moveTo(size / 2, size * 0.9);
    path.quadraticBezierTo(size * 0.2, size * 0.6, size * 0.2, size * 0.4);
    path.quadraticBezierTo(size * 0.2, size * 0.1, size / 2, size * 0.1);
    path.quadraticBezierTo(size * 0.8, size * 0.1, size * 0.8, size * 0.4);
    path.quadraticBezierTo(size * 0.8, size * 0.6, size / 2, size * 0.9);
    path.close();

    final paint = Paint()
      ..color = AppColors.color34D8FD
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(path, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppStyles.STYLE_18_BOLD.copyWith(
          color: AppColors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      (size - textPainter.width) / 2,
      (size - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);

    final circleCenter = Offset(size * 0.7, size * 0.22);
    final circleRadius = size * 0.1;
    final circlePaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.hotel.codePoint),
        style: TextStyle(
          fontSize: circleRadius * 2,
          fontFamily: Icons.hotel.fontFamily,
          package: Icons.hotel.fontPackage,
          color: AppColors.color34D8FD,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    final iconOffset = Offset(
      circleCenter.dx - iconPainter.width / 2,
      circleCenter.dy - iconPainter.height / 2,
    );
    iconPainter.paint(canvas, iconOffset);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}
