import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/models/user_model.dart';

class SaveFriendsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String ComplateAddress = "";

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
  }
  void increment() => count.value++;

  void saveFriend(String uid, List<UserModel> otherUser) {}
}
