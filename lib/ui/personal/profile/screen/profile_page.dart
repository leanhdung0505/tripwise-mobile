import 'package:flutter/material.dart';
import 'package:trip_wise_app/common/base/controller/base_page_widget.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends BasePage<ProfileController> {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Page')),
    );
  }
}
