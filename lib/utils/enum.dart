import 'package:get/get.dart';

import '../resource/asset/app_images.dart';

enum DatePickerType {
  date,
  hour,
  minute,
  number,
}

enum TimePeriod {
  AM,
  PM,
}

enum PickerType { date, time }

enum TimeField { start, end }

enum MenuItem {
  home(AppImages.icTravel, AppImages.icTravel, 'trips', 0),
  share(AppImages.icShare, AppImages.icShare, 'share', 1),
  favorite(AppImages.icLovely, AppImages.icLovely, 'favorite', 2),
  profile(AppImages.icSetting, AppImages.icSetting, 'setting', 3);

  final String iconPath;
  final String iconSelectedPath;
  final String label;
  final int id;

  const MenuItem(this.iconPath, this.iconSelectedPath, this.label, this.id);
}
extension MenuItemExtension on MenuItem { 
  String get translatedLabel => label.tr;
}
