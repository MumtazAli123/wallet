import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {

  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final upperCaseTextFormatter = textUpperCaseTextFormatter();
  final username = TextEditingController();

  final GlobalKey<FormState>  formKey = GlobalKey<FormState>();
  File? image;
  ImagePicker? imagePicker;
  String imageUrl = '';


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
  //     return TextInputFormatter.withFunction((oldValue, newValue) {
    //       if (newValue.text.isEmpty) {
    //         return newValue.copyWith(text: newValue.text);
    //       } else if (newValue.text.length == 1) {
    //         return newValue.copyWith(
    //             text: newValue.text[0].toUpperCase() + newValue.text.substring(1));
    //       }
    //       return newValue.copyWith(
    //           text: newValue.text[0].toUpperCase() +
    //               newValue.text.substring(1).toLowerCase());
    //     });
  }

}
