import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trip_wise_app/ui/main/controller/main_controller.dart';

import '../../../common/base/widgets/base_page_widget.dart';
import '../../../common/base/widgets/custom_navigation_bar.dart';

class MainPage extends BasePage<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _buildPageTransition()),
      bottomNavigationBar: Obx(
        () => CustomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onItemTapped: (index) => controller.updateIndex(index),
        ),
      ),
    );
  }

  Widget _buildPageTransition() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        // Xác định hướng slide dựa trên index
        final slideDirection = _getSlideDirection();

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(slideDirection, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      child: _getCurrentPage(),
    );
  }

  double _getSlideDirection() {
    final currentIndex = controller.currentIndex.value;
    final previousIndex = controller.previousIndex.value;

    // Nếu chuyển sang trang bên phải (index lớn hơn) -> slide từ phải sang trái
    if (currentIndex > previousIndex) {
      return 1.0; // Slide from right
    } else {
      return -1.0; // Slide from left
    }
  }

  Widget _getCurrentPage() {
    final currentIndex = controller.currentIndex.value;
    return KeyedSubtree(
      key: ValueKey(currentIndex),
      child: controller.pages[currentIndex] ?? Container(),
    );
  }
}
