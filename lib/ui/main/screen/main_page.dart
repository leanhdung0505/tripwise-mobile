import 'package:flutter/material.dart';
import 'package:trip_wise_app/ui/main/controller/main_controller.dart';

import '../../../common/base/widgets/base_page_widget.dart';

class MainPage extends BasePage<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.pink,
    ));
  }
}
