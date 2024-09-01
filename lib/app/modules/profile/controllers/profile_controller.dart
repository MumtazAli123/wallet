import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/global/global.dart';

class ProfileController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    addressController.dispose();
  }
  void increment() => count.value++;

  // get user data
  void getUserData() {
    try {
     FirebaseFirestore.instance
         .collection('sellers')
         .doc(sharedPreferences!.getString('uid'))
         .get().then((DocumentSnapshot user) {
        if (user.exists) {
          print('Document exists on the database');
          print(user.data());
        } else {
          print('Document does not exist on the database');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void updateProfile() {
    print(nameController.text);
    print(phoneController.text);
    print(cityController.text);
    print(addressController.text);
  }

}
