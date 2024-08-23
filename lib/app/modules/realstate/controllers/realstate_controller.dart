import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../../../../global/global.dart';
import '../../../../models/realstate_model.dart';

class RealStateController extends GetxController {
  TextEditingController realStateNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<String> realStateType = [
    'House',
    'Apartment',
    'Office',
    'Land',
    'Shop',
    'Other'
  ];
  List<String> realStateStatus = ['Rent', 'Sale', 'Lease', 'Other'];
  List<String> realStateFurnishing = [
    'Furnished',
    'Semi-Furnished',
    'Unfurnished',
    'Other'
  ];
  List<String> realStateCondition = [
    'New',
    'Ready to move',
    'Used',
    'Under Construction',
    'Other'
  ];
  // currency list
  List<String> currencyList = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AUD',
    'CAD',
    'HKD',
    'TRY',
    'INR',
    'AED',
    'SAR',
    'QAR',
    'PKR',
    'BHD',
    "MYR"

    ];

  String? realStateTypeValue;
  String? realStateStatusValue;
  String? realStateFurnishingValue;
  String? conditionValue;
  String? currencyValue;

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

  var realStateModel = RealStateModel().obs;

  var likeCount = 0.obs;
  var isLiked = false.obs;



  void likeUnlike(doc) {
    if (isLiked.value) {
      FirebaseFirestore.instance
          .collection("realState")
          .doc(doc['realStateId'])
          .update({'likeCount': FieldValue.increment(-1)});
      isLiked.value = false;
    } else {
      FirebaseFirestore.instance
          .collection("realState")
          .doc(doc['realStateId'])
          .update({'likeCount': FieldValue.increment(1)});
      isLiked.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    houseDataStream();
    priceController = TextEditingController();
    realStateNameController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {
    realStateNameController.dispose();
    priceController.dispose();
    descController.dispose();
  }

  realStateStream() {
    return FirebaseFirestore.instance
        .collection("sellers")
        .doc(user!.uid)
        .collection("realState")
        .orderBy("publishedDate", descending: true)
        .snapshots();
  }

  // edit realState
  editRealState(RealStateModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(user!.uid)
          .collection("realState")
          .doc(model.realStateId)
          .update(model.toJson())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("realState")
            .doc(model.realStateId)
            .update(model.toJson());
        Get.back();
        Get.snackbar("Success", "Real State Updated Successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      });
    } catch (e) {
     wGetSnackBar("Error", e.toString());
    }
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
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  //   get all data realState
  allStateStream() {
    // realState database
    return FirebaseFirestore.instance
        .collection("realState")
        .orderBy("publishedDate", descending: true)
        .snapshots();
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
    // .orderBy('date', descending: true)
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
        // date wise data
        // .orderBy('date', descending: true)
        .where('realStateType', isEqualTo: 'Shop')
        .snapshots();
  }

  void updateRealState(RealStateModel model) {
    realStateModel.value = model;
  }

  void updateRating(doc, double value) {
    FirebaseFirestore.instance
        .collection("realState")
        .doc(doc['realStateId'])
        .update({'rating': value});
  }

  getRealState(id) {
    return FirebaseFirestore.instance
        .collection("realState")
        .doc(id)
        .get()
        .then((value) => value.data());
  }

  removeLike(doc, String uid) {
    FirebaseFirestore.instance
        .collection("realState")
        .doc(doc)
        .update({'likeCount': FieldValue.increment(-1)});
    FirebaseFirestore.instance
        .collection("realState")
        .doc(doc)
        .collection("likes")
        .doc(uid)
        .delete();
  }

  addLike(doc, String uid) {
    FirebaseFirestore.instance
        .collection("realState")
        .doc(doc)
        .update({'likeCount': FieldValue.increment(1)});
    FirebaseFirestore.instance
        .collection("realState")
        .doc(doc)
        .collection("likes")
        .doc(uid)
        .set({'like': true});
  }

  void likeRealState(doc) {
    addLike(doc, user!.uid);
  }
}
