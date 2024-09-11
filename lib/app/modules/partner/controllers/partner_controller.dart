import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/widgets/mix_widgets.dart';

class PartnerController extends GetxController {
  TextEditingController bioController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController languagesController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController professionController = TextEditingController();

  List<String> languages = [];
  List<String> education = [];
  List<String> weight = [];
  List<String> kids = ['Yes', 'No'];
  List<String> wantKids = ['Yes', 'No'];
  List<String> maritalStatus = [
    'Single',
    'Married',
    "Engage",
    "Divorced",
    "Widow",
    "Widower",
    "Other"
  ];
  List<String> living = ['Alone', 'With Family', 'With Friends', 'Other'];
  List<String> smoking = ['Yes', 'No', 'Occasionally'];
  List<String> drinking = ['Yes', 'No', 'Occasionally'];
  List<String> bodyType = ['Slim', 'Average', 'Athletic', 'Heavy'];
  List<String> lookingForInAPartner = [
    'Friendship',
    'Relationship',
    'Marriage',
    'Other'
  ];
  List<String> genderType = [
    "Male",
    "Female",
  ];

  String? language = '';
  String? educationLevel = '';
  String? professionValue = '';
  String? kid = 'Yes';
  String? wantKid = 'Yes';
  String? marital = 'Single';
  String? live = 'Alone';
  String? smoke = 'Yes';
  String? drink = 'Yes';
  String? drinkList = 'Yes';
  String? body = 'Slim';
  String? lookingFor = 'Friendship';
  String? genderValue = "Male";
  int? age = 0;
  String? imageUrl = '';

  final currentScreen = 0.obs;

  late Rx<File?> pickedFile;

  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  final fFirestore = FirebaseFirestore.instance;
  final fAuth = FirebaseAuth.instance;
  final fStorage = FirebaseStorage.instance;



  void selectImage() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      pickedFile.value = File(imageFile!.path);
    }
  }

  void removeImage() {
    pickedFile.value = null;
  }

  void createNewUserAccount() async {
    try {
      if (pickedFile.value != null) {
        var snapshot = await fStorage
            .ref()
            .child('profileImages/${fAuth.currentUser!.uid}')
            .putFile(pickedFile.value!);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrl = downloadUrl;
      }

      await fFirestore.collection('users').doc(fAuth.currentUser!.uid).set({
        'uid': sharedPreferences!.getString('uid'),
        'name': sharedPreferences!.getString('name'),
        'email': sharedPreferences!.getString('email'),
        'phone': sharedPreferences!.getString('phone'),
        'image': imageUrl,
        'bio': bioController.text,
        'income': incomeController.text,
        'religion': religionController.text,
        "Nationality": nationalityController.text,
        "age": age,
        "dob": dobController.text,
        "gender": genderValue,
        "language": languages,
        "education": education,
        "profession": professionValue,
        "kids": kid,
        "wantKids": wantKid,
        "maritalStatus": marital,
        "living": live,
        "smoking": smoke,
        "drinking": drinkList,
        "bodyType": body,
        "lookingForInAPartner": lookingFor,
      });

      Get.offAllNamed('/home');
      wGetSnackBar(
        "Success",
        "Profile created successfully",
      );
    } catch (e) {
      Get.back();
      QuickAlert.show(
        context: Get.context!,
        title: "Error",
        text: e.toString(),
        type: QuickAlertType.error,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    // usersProfilesList.bindStream(FirebaseFirestore.instance
    //     .collection('sellers')
    //     .where("uid", isEqualTo: fAuth.currentUser!.uid)
    //     .snapshots()
    //     .map((snapshot) {
    //   List<UserModel> profilesList = [];
    //   for (var eachProfile in snapshot.docs) {
    //     profilesList.add(UserModel.fromDataSnapshot(eachProfile));
    //   }
    //   return profilesList;
    // }));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  allProductsStream() {
    return FirebaseFirestore.instance
        .collection("products")
        .orderBy("pCreatedAt", descending: true)
        .snapshots();
  }

  void saveProfile() async {
    try {
      QuickAlert.show(
        context: Get.context!,
        title: "Saving",
        text: "Please wait...",
        type: QuickAlertType.loading,
      );

      if (pickedFile.value != null) {
        var snapshot = await fStorage
            .ref()
            .child('profileImages/${fAuth.currentUser!.uid}')
            .putFile(pickedFile.value!);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrl = downloadUrl;
      }

      await fFirestore.collection('users').doc(fAuth.currentUser!.uid).set({
        'uid': sharedPreferences!.getString('uid'),
        'name': sharedPreferences!.getString('name'),
        'email': sharedPreferences!.getString('email'),
        'phone': sharedPreferences!.getString('phone'),
        'image': imageUrl,
        'bio': bioController.text,
        'income': incomeController.text,
        'religion': religionController.text,
        "Nationality": nationalityController.text.trim(),
        "age": age,
        "dob": dobController.text,
        "gender": genderValue,
        "language": languages,
        "education": education,
        "profession": professionValue,
        "kids": kid,
        "wantKids": wantKid,
        "maritalStatus": marital,
        "living": live,
        "smoking": smoke,
        "drinking": drinkList,
        "bodyType": body,
        "lookingForInAPartner": lookingFor,

      });

      Get.offAllNamed('/home');
      wGetSnackBar(
        "Success",
        "Profile created successfully",
        color: Colors.green,
      );
    } catch (e) {
      Get.back();
      QuickAlert.show(
        context: Get.context!,
        title: "Error",
        text: e.toString(),
        type: QuickAlertType.error,
      );
    }
  }
}
