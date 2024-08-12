import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../../../../global/global.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  FocusNode? emailAddressFocusNode;
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();

  final passwordFocusNode = FocusNode();

  final auth = FirebaseAuth.instance;

  var isLoading = true.obs;

  var email = '';
  var password = '';

  var isRememberMe = false.obs;

  final count = 0.obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    emailAddressFocusNode?.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
  }

  void increment() => count.value++;

  void login() {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
      //   if email is wrong @ , .com , .net
    } else if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter valid email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    // in email do not use emoji
    else if (GetUtils.hasMatch(emailController.text, r'[^\x00-\x7F]+')) {
      Get.snackbar('Error', 'Please enter valid email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    } else if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
      //   save email and password in shared preference
    } else if (isRememberMe.value) {
      sharedPreferences!.setString('email', emailController.text);
      sharedPreferences!.setString('password', passwordController.text);
    } else {
      loginNow();
    }
  }

  loginNow() async {
    try {
      QuickAlert.show(
          // if have to show dialog error message then not use loading dialog
          context: Get.context!,
          title: 'Logging in',
          text: 'Please wait...',
          width: 400,
          type: QuickAlertType.loading);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        checkIfSellerRecordExist(currentUser);
      }
    } catch (e) {
      Get.back();
      QuickAlert.show(
        width: 400,
          context: Get.context!,
          title: 'Error',
          text: 'User not found or wrong password',
          type: QuickAlertType.error);
    }
  }

  checkIfSellerRecordExist(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      if (record.exists) {
        if (record.data()!['status'] == 'approved') {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!
              .setString("sellerType", record.data()!['sellerType']);
          await sharedPreferences!
              .setString("status", record.data()!['status']);
          await sharedPreferences!.setString("email", record.data()!['email']);
          await sharedPreferences!.setString("name", record.data()!['name']);
          await sharedPreferences!.setString("image", record.data()!['image']);
          await sharedPreferences!.setString("phone", record.data()!['phone']);

          Get.back();
          Get.offAllNamed('/home');
          // Get.to(() => const BottomPageView());
          Get.snackbar('Success', 'Login successful',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else if (record.data()!['status'] == 'pending') {
          wGetSnackBar('Error', 'Your account is not approved yet');
        } else {
          Get.back();
          QuickAlert.show(
            width: 400,
              context: Get.context!,
              title: 'Error',
              text: 'Your account is not approved yet',
              type: QuickAlertType.error);
        }
      }
    });
  }

  void facebookSignIn() {}
}
