import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import '../../../../common/base/controller/observer_func.dart';
import '../../../../common/base/storage/local_data.dart';
import '../../../../common/repository/user_repository.dart';
import '../../../../common/repository/user_repository_impl.dart';
import 'dart:io';
import '../../../../data/model/user/user_model.dart';
class ProfileController extends BaseController {
  static ProfileController get to => Get.find<ProfileController>();
  final UserRepository _userRepository = UserRepositoryImpl();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController fullNameController;

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool hasChanges = false.obs;
  RxBool isLoading = false.obs;

  String? originalUsername;
  String? originalFullName;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _addListeners();
  }

  void _initializeControllers() {
    final user = LocalData.shared.user;
    emailController = TextEditingController(text: user?.email ?? '');
    usernameController = TextEditingController(text: user?.username ?? '');
    fullNameController = TextEditingController(text: user?.fullName ?? '');

    originalUsername = user?.username;
    originalFullName = user?.fullName;
  }

  void _addListeners() {
    usernameController.addListener(_checkChanges);
    fullNameController.addListener(_checkChanges);
  }

  void _checkChanges() {
    hasChanges.value = selectedImage.value != null ||
        usernameController.text != originalUsername ||
        fullNameController.text != originalFullName;
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
        _checkChanges();
      }
    } catch (e) {
      showSimpleErrorSnackBar(message: "failedToPickImage".tr);
    }
  }

  Future<void> saveChanges() async {
    if (!hasChanges.value) return;

    isLoading.value = true;

    try {
      String? imageUrl;

      if (selectedImage.value != null) {
        imageUrl = await _uploadAvatar();
      }
      await _updateUserProfile(imageUrl);
    } catch (e) {
      showSimpleErrorSnackBar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _uploadAvatar() async {
    String? imageUrl;

    await subscribe(
      future: _userRepository.updateAvatar(selectedImage.value?.path ?? ''),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          imageUrl = response.body['data']['image_url'];
        },
        onError: (error) {
          throw Exception(error.message ?? "failedToUploadAvatar".tr);
        },
      ),
      isShowLoading: false,
    );

    return imageUrl;
  }

  Future<void> _updateUserProfile(String? imageUrl) async {
    final updateData = _buildUpdateData(imageUrl);

    if (updateData.isEmpty) return;

    await subscribe(
      future: _userRepository.updateUser(updateData),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) async {
          _updateLocalUserData(updateData);
          await _refreshUserData();
          _resetForm();
          showSimpleSuccessSnackBar(message: "profileUpdatedSuccessfully".tr);
        },
        onError: (error) {
          showSimpleErrorSnackBar(
              message: error.message ?? "failedToUpdateProfile".tr);
        },
      ),
      isShowLoading: false,
    );
  }

  Future<void> _refreshUserData() async {
    await subscribe(
      future: _userRepository.getUser(),
      observer: ObserverFunc(
        onSubscribe: () {},
        onSuccess: (response) {
          final user = UserModel.fromJson(response.body['data']);
          LocalData.shared.user = user;
          _initializeControllers();
        },
        onError: (error) {
          showSimpleErrorSnackBar(
              message: error.message ?? "failedToRefreshData".tr);
        },
      ),
      isShowLoading: false,
    );
  }

  Map<String, dynamic> _buildUpdateData(String? imageUrl) {
    final updateData = <String, dynamic>{};

    if (usernameController.text != originalUsername) {
      updateData['username'] = usernameController.text;
    }
    if (fullNameController.text != originalFullName) {
      updateData['full_name'] = fullNameController.text;
    }
    if (imageUrl != null) {
      updateData['profile_picture'] = imageUrl;
    }

    return updateData;
  }

  void _updateLocalUserData(Map<String, dynamic> updateData) {
    final user = LocalData.shared.user;
    if (user == null) return;

    if (updateData.containsKey('username')) {
      user.username = updateData['username'];
    }
    if (updateData.containsKey('full_name')) {
      user.fullName = updateData['full_name'];
    }
    if (updateData.containsKey('profile_picture')) {
      user.profilePicture = updateData['profile_picture'];
    }

    LocalData.shared.user = user;
  }

  void _resetForm() {
    final user = LocalData.shared.user;
    originalUsername = user?.username;
    originalFullName = user?.fullName;
    selectedImage.value = null;
    hasChanges.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}
