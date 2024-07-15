import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../global/global.dart';
import '../../../../models/realstate_model.dart';

class RealStateController extends GetxController {
  final TextEditingController realStateNameController = TextEditingController();

  String? realStateAmenitiesValue = 'Gym';
  String? realStateRatingValue = '1';
  var countryValue = "".obs;
  var stateValue = "".obs;
  var cityValue = "".obs;

  var isUpLoading = false.obs;
  var downloadImageUrl = "".obs;
  var realStateList = <RealStateModel>[].obs;
  var realStateUniqueID = DateTime.now().millisecondsSinceEpoch.toString().obs;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    houseDataStream();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  realStateStream() {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("realState")
        .snapshots();
  }

  //   delete
  deleteRealState(String realStateId) async {
    try {
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(sharedPreferences?.getString('uid'))
          .collection("realState")
          .doc(realStateId)
          .delete()
          .then((value) {
        FirebaseFirestore.instance
            .collection("realState")
            .doc(realStateId)
            .delete();
        Get.snackbar("Success", "Real State Deleted Successfully",
            backgroundColor: Colors.red, colorText: Colors.white);
      });
    } catch (e) {
      print(e);
    }
  }

  //   get all data realState
  allStateStream() {
    // realState database
    return FirebaseFirestore.instance.collection("realState").snapshots();
  }

//   get data just house
  houseDataStream() {
    return FirebaseFirestore.instance
        .collection("realState")
        .where('realStateType', isEqualTo: 'House')
        .snapshots();
  }

//   get data apartment
  apartmentDataStream() {
    return FirebaseFirestore.instance
        .collection("realState")
        .where('realStateType', isEqualTo: 'Apartment')
        .snapshots();
  }

  //  get data land
  landDataStream() {
    return FirebaseFirestore.instance
        .collection("realState")
        .where('realStateType', isEqualTo: 'Land')
        .snapshots();
  }

  // get data office
  officeDataStream() {
    return FirebaseFirestore.instance
        .collection("realState")
        .where('realStateType', isEqualTo: 'Office')
        .snapshots();
  }

  // get data shop
  shopDataStream() {
    return FirebaseFirestore.instance
        .collection("realState")
        .where('realStateType', isEqualTo: 'Shop')
        .snapshots();
  }
}
