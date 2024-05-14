// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/models/user_model.dart';


class SendMoneyController extends GetxController {
  // var noteList = List.empty(growable: true).obs;
  var searchList = List.empty(growable: true).obs;
  var searchOtherUser = ''.obs;
  var isSearching = false.obs;

  var searchProduct = ''.obs;

  final db = FirebaseFirestore.instance.collection("sellers").snapshots();

  var otherUsers = List.empty(growable: true).obs;
  var user = FirebaseAuth.instance.currentUser;


  UserModel loggedInUser = UserModel();

  final transferNominalController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  final count = 0.obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    getOtherUsers('');

  }

  @override
  void onReady() {
    // super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    transferNominalController.dispose();
    descriptionController.dispose();
  }

  void increment() => count.value++;
  void decrement() => count.value--;

  void getOtherUsers(String query) async {
    // sellers
    otherUsers.clear();
    if (query.isNotEmpty) {
      isSearching.value = true;
      await FirebaseFirestore.instance
          .collection('sellers')
          .orderBy('name')
          .where('name', isEqualTo : query)
          .get()
          .then((value) =>searchList.value = value.docs);
    } else {
      isSearching.value = false;
    }
  }


}
