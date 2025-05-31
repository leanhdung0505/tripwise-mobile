import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/ui/main/controller/main_controller.dart';

import '../../../common/base/widgets/base_page_widget.dart';
import '../../../common/base/widgets/custom_navigation_bar.dart';
import '../../../utils/enum.dart';

class MainPage extends BasePage<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: List.generate(MenuItem.values.length, (index) => controller.pages[index] ?? Container())
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onItemTapped: controller.updateIndex,
        ),
      ),
    );
  }
}
