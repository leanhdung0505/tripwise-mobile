import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DateTimeUtils {
  static String formatDateTime(
    DateTime dateTime, {
    String? pattern,
    String? locale,
  }) {
    locale ??= Intl.defaultLocale;
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(dateTime);
  }

  static String calculateTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'durationSeconds'
          .trParams({'time': difference.inSeconds.toString()});
    } else if (difference.inMinutes < 60) {
      return 'durationMinutes'
          .trParams({'time': difference.inMinutes.toString()});
    } else if (difference.inHours < 24) {
      return 'durationHours'.trParams({'time': difference.inHours.toString()});
    } else if (difference.inDays < 31) {
      return 'durationDays'.trParams({'time': difference.inDays.toString()});
    } else if (difference.inDays < 365) {
      return 'durationMonths'
          .trParams({'time': (difference.inDays / 30).floor().toString()});
    } else {
      return 'durationYears'
          .trParams({'time': (difference.inDays / 365).floor().toString()});
    }
  }

  static DateTime? tryParse(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateTimeUtils.formatDateTime(
      this,
      pattern: 'MMM dd yyyy',
      locale: Get.locale?.toString(),
    );
  }

  String formatDateNoText() {
    return DateTimeUtils.formatDateTime(
      this,
      pattern: 'yyyy-MM-dd',
      locale: Get.locale?.toString(),
    );
  }
  String formatMonthDate() {
    return DateTimeUtils.formatDateTime(
      this,
      pattern: 'MMM dd',
      locale: Get.locale?.toString(),
    );
  }

  String formatTime() {
    return DateTimeUtils.formatDateTime(
      this,
      pattern: 'HH:mm',
      locale: Get.locale?.toString(),
    );
  }
  
  String timeAgo() {
    return DateTimeUtils.calculateTimeAgo(this);
  }
}
