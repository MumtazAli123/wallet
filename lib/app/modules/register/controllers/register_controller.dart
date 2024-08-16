import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/home/views/bottom_page_view.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/user_model.dart';
import 'package:wallet/notification/push_notification_sys.dart';


class RegisterController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
   TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final upperCaseTextFormatter = textUpperCaseTextFormatter();
  TextEditingController otpController = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController descController = TextEditingController();

  EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imageMob;
  ImagePicker? imagePicker;
  Uint8List selectedWebImage = Uint8List(8);
  String imageUrl = '';
  final currentScreen = 0.obs;
  bool isLoading = false;

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

  late Rx<File?> pickedFile;

  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  pickImage(ImageSource gallery) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      Get.snackbar('Success', 'Image Picked');
      pickedFile = Rx<File?>(File(imageFile!.path));
    } else {
      Get.snackbar('Error', 'No Image Selected');
    }
  }

  captureImage(ImageSource camera) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      Get.snackbar('Success', 'Image Captured');
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  @override
  void onInit() {
    super.onInit();
    countryCode = selectedCountry.phoneCode;
    nameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    descController = TextEditingController();
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

  Future<void> editProfileAndUpdate(UserModel model) async {
   try {
     QuickAlert.show(
         context: Get.context!,
         type: QuickAlertType.loading,
          title: 'Updating Profile',
     );
      FirebaseFirestore.instance.collection('sellers')
          .doc(user!.uid)
          .update({
        'name': nameController.text,
        'address': addressController.text,
        'city': cityController.text,
        'description': descController.text,
      }).then((value) {
        FirebaseFirestore.instance.collection('sellers')
            .doc(user!.uid)
            .collection('rating')
            .doc(user!.uid)
            .update({
          'name': nameController.text,
        });
        // update shared preferences
         sharedPreferences!.setString('name', nameController.text);
         sharedPreferences!.setString('address', addressController.text);
         sharedPreferences!.setString('city', cityController.text);
         sharedPreferences!.setString('description', descController.text);

            QuickAlert.show(
              context: Get.context!,
              title: 'Success',
              type: QuickAlertType.success,
            );
            Get.offAll(() => const BottomPageView());
           QuickAlert.show(
             context: Get.context!,
             title: 'Success',
             type: QuickAlertType.success,
           );
           Get.offAll(() => const BottomPageView());
         });


    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        title: 'Error',
        type: QuickAlertType.error,
      );
    }
  }

  static textUpperCaseTextFormatter() {
    // first letter use capital after space  letter use small if type space then same logic apply
    return TextInputFormatter.withFunction((oldValue, newValue) {
      try {
        if (newValue.text.contains(' ')) {
          return newValue.copyWith(
            text: newValue.text
                .split(' ')
                .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
                .join(' '),
          );
        } else if (newValue.text.length == 1) {
          return newValue.copyWith(
              text: newValue.text[0].toUpperCase() +
                  newValue.text.substring(1).toLowerCase());
        } else if (newValue.text.length > 1) {
          return newValue.copyWith(
              text: newValue.text[0].toUpperCase() +
                  newValue.text.substring(1).toLowerCase());
        }
      } catch (e) {
        return newValue.copyWith(text: newValue.text);
      }
     if (newValue.text.contains(' ')) {
        return newValue.copyWith(
          text: newValue.text
              .split(' ')
              .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
              .join(' '),
        );
      }
      return newValue;
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
