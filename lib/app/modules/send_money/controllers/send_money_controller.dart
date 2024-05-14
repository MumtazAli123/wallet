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
    await FirebaseFirestore.instance.collection('sellers').get().then((value) {
      value.docs.forEach((element) {
        if (element.id != user!.uid) {
          otherUsers.add(UserModel.fromMap(element.data()));
        }
      });
    });
    if (query.isEmpty) {
      searchList.clear();
      isSearching.value = false;
    } else {
      isSearching.value = true;
      searchList.clear();
      // if search name any type letter in search bar then show the result
      otherUsers.forEach((element) {
        if (element.name!.toLowerCase().contains(query.toLowerCase())) {
          searchList.add(element);
        }
      });
    }
  }


}
