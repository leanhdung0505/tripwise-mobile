import 'package:flutter/material.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import '../controller/favorite_controller.dart';

class FavoritePage extends BasePage<FavoriteController> {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Favorite Page')),
    );
  }
}
