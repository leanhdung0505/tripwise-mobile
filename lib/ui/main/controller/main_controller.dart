import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';

import '../../favorite/screen/favorite_page.dart';
import '../../home/screen/home_page.dart';
import '../../personal/setting/screen/setting_page.dart';
import '../../share/screen/share_page.dart';

class MainController extends BaseController {
  static MainController get to => Get.find<MainController>();

  final pages = <int, Widget>{0: const HomePage()}.obs;

  var currentIndex = 0.obs;
  final previousIndex = 0.obs;

  // Cập nhật index với tracking previous cho slide animation
  void updateIndex(int index) {
    if (currentIndex.value != index) {
      previousIndex.value = currentIndex.value;
      currentIndex.value = index;

      if (!pages.containsKey(index)) {
        pages[index] = _getPageByIndex(index);
      }
    }
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const SharePage();
      case 2:
        return const FavoritePage();
      case 3:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize previous index
    previousIndex.value = currentIndex.value;
  }
}
