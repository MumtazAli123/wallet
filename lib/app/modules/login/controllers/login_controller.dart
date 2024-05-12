import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

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
    if(emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    //   if email is wrong @ , .com , .net
    }else if(!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter valid email', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    else if(passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter password');
      return;
    //   save email and password in shared preference
    }else if(isRememberMe.value) {
      sharedPreferences!.setString('email', emailController.text);
      sharedPreferences!.setString('password', passwordController.text);
    }
    else {
      loginNow();

    }
  }

  loginNow() async {
    QuickAlert.show(
        // time: duration ?? Duration(seconds: 3),
        context: Get.context!,
        title: 'Logging in',
        text: 'Please wait...',
        type: QuickAlertType.loading);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        checkIfSellerRecordExist(currentUser);
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
       Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');

      }
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
          Get.snackbar('Success', 'Login successful');
        }else if(record.data()!['status'] == 'pending') {
          Get.snackbar('Error', 'Your account is not approved yet', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        }
        else {
          Get.snackbar('Error', 'Your account is not approved yet', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    });
  }
}
