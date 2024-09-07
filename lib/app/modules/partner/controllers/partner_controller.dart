import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';

class PartnerController extends GetxController {
  TextEditingController bioController = TextEditingController();
  TextEditingController profileHeadingController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  List<String> languages = [];
  List<String> education = [];
  List<String> weight = [];
  List<String> profession = [];
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
  List<String> height = [
    '4.0',
    '4.1',
    '4.2',
    '4.3',
    '4.4',
    '4.5',
    '4.6',
    '4.7',
    '4.8',
    '4.9',
    '4.10',
    '4.11',
    '5.0',
    '5.1',
    '5.2',
    '5.3',
    '5.4',
    '5.5',
    '5.6',
    '5.7',
    '5.8',
    '5.9',
    '5.10',
    '5.11',
    '6.0',
    '6.1',
    '6.2',
    '6.3',
    '6.4',
    '6.5',
    '6.6',
    '6.7',
    '6.8',
    '6.9',
    '6.10',
    '6.11',
    '7.0',
    '7.1',
    '7.2',
    '7.3',
    '7.4',
    '7.5',
    '7.6',
    '7.7',
    '7.8',
    '7.9',
    '7.10',
    '7.11',
    '8.0'
  ];
  List<String> genderType = ["Male", "Female",];


  String? language = '';
  String? educationLevel = '';
  String? weightLevel = '';
  String? professionLevel = '';
  String? kid = 'Yes';
  String? wantKid = 'Yes';
  String? marital = 'Single';
  String? live = 'Alone';
  String? smoke = 'Yes';
  String? drinkList = 'Yes';
  String? body = 'Slim';
  String? lookingFor = 'Friendship';
  String? heightLevel = '4.0';
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

      await fFirestore.collection('users').doc(fAuth.currentUser!.uid)
          .set({
        'uid': sharedPreferences!.getString('uid'),
        'name': sharedPreferences!.getString('name'),
        'email': sharedPreferences!.getString('email'),
        'phone': sharedPreferences!.getString('phone'),
        'image': imageUrl,
        'bio': bioController.text,
        'profileHeading': profileHeadingController.text,
        'income': incomeController.text,
        'religion': religionController.text,
        "age": age,
        "dob": dobController.text,
        "gender": genderValue,
      });


      Get.offAllNamed('/home');
      QuickAlert.show(
        context: Get.context!,
        title: "Success",
        text: "Profile created successfully",
        type: QuickAlertType.success,
      );
    } catch (e) {
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
}

