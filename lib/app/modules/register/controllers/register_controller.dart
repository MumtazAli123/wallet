import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/notification/push_notification_sys.dart';

import '../../../../user_profile/user_profile.dart';

class RegisterController extends GetxController {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final upperCaseTextFormatter = textUpperCaseTextFormatter();
  final TextEditingController otpController = TextEditingController();
  final username = TextEditingController();
  final descController = TextEditingController();

  EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imageMob;
  ImagePicker? imagePicker;
  Uint8List selectedWebImage = Uint8List(8);
  String imageUrl = '';
  final currentScreen = 0.obs;

  final FocusNode nameFocus = FocusNode();

  var countryCode = '';
  var flagUri = '';
  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: "0300 1234567",
    displayName: "Pakistan",
    displayNameNoCountryCode: "PK",
    e164Key: "",
  );

  Map<String, String> get remoteServerConfiguration => {
        'server': 'smtp.gmail.com',
        'port': '587',
        'email': 'kad.dadu@gmail.com',
        'password': 'Mart@2022',
      };

  @override
  void onInit() {
    super.onInit();
    countryCode = selectedCountry.phoneCode;
  }

  @override
  void onReady() {
    // super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    username.dispose();
    descController.dispose();
  }

  void editProfileAndUpdate() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .update({
          'name': nameController.text.trim(),
          'address': emailController.text.trim(),
          'city': phoneController.text.trim(),
        })

        .then((value) async{
          await sharedPreferences!.setString('name', nameController.text.trim());
          await sharedPreferences!.setString('address', emailController.text.trim());
          await sharedPreferences!.setString('city', phoneController.text.trim());
      Get.to(() => const ProfileScreen());
      Get.snackbar("Success", "Vehicle Updated Successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      // Get.to(() => const ShowVehicleView());
    });
  }

  static textUpperCaseTextFormatter() {
    // first letter use capital and other letter use small if type space then same logic apply
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue.copyWith(text: newValue.text);
      } else if (newValue.text.length == 1) {
        return newValue.copyWith(
            text: newValue.text[0].toUpperCase() + newValue.text.substring(1));
      }
      return newValue.copyWith(
          text: newValue.text[0].toUpperCase() +
              newValue.text.substring(1).toLowerCase());
    });
  }

  var status = "".obs;

  Future<void> sendOtp(String email) async {
    var res = await emailAuth.sendOtp(recipientMail: email);
    if (res) {
      status.value = "OTP sent";
    } else {
      status.value = "OTP not sent";
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    var res = emailAuth.validateOtp(recipientMail: email, userOtp: otp);
    if (res) {
      status.value = "OTP verified";
    } else {
      status.value = "Invalid OTP";
    }
  }
}
