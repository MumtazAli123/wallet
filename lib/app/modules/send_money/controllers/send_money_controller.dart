// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/models/user_model.dart';

class SendMoneyController extends GetxController {
  var isSearching = false.obs;

  var searchList = List.empty(growable: true).obs;

  final searchController = TextEditingController();

  var isLoading = true.obs;

  var otherUsers = List<UserModel>.empty(growable: true).obs;

  var selectedUser = UserModel().obs;

  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    // super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  void getOtherUsers(String query) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('sellers')
          .orderBy('name')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get()
          .then((value) => searchList.value = value.docs);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
