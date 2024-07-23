// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wallet/models/address_model.dart';
import 'package:wallet/models/user_model.dart';


class SendMoneyController extends GetxController {
  var isSearching = false.obs;

  var searchOtherUserList = List.empty(growable: true).obs;

  final searchController = TextEditingController();

  var isLoading = true.obs;

  var otherUsers = List<UserModel>.empty(growable: true).obs;

  var selectedUser = UserModel().obs;
  var selectedUserF = AddressModel().obs;

  final upperCaseTextFormatter = textUpperCaseTextFormatter();

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
  }

  Future<void> getOtherUsers(String query, ) async {
    //   is searching in the lower case and upper case then show rhe user no problem
    try {
      isLoading(true);
      //   do not search same use or get the current user data

      final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('sellers')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get()
          .then((value) {
            searchOtherUserList.value = value.docs;
        otherUsers.clear();
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            if (element.id != currentUser!.uid) {
              otherUsers.add(UserModel.fromMap(element.data()));
            }
          });
        } else {
          otherUsers.clear();
        }

      });
      // await FirebaseFirestore.instance
      //     .collection('sellers')
      //    .orderBy('name')
      //     .startAt([query])
      //     .endAt(['$query\uf8ff'])
      //     .where("name", isGreaterThanOrEqualTo: query)
      //     .where("name", isLessThanOrEqualTo: '$query\uf8ff')
      //     .limit(10)
      //     .get()
      //     .then((value) {
      //   searchList.value = value.docs;
      //   if (value.docs.isNotEmpty) {
      //     searchList.value = value.docs;
      //   } else {
      //     otherUsers.clear();
      //   }
      // });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void searchUser(String value) {
    // do not search same user or do not get the current user data
    if (value.isNotEmpty) {
      getOtherUsers(value);
    } else {
      otherUsers.clear();
    }

  }

  static textUpperCaseTextFormatter() {
    // every first word first letter use capital and other letter use small
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isNotEmpty) {
        if (oldValue.text.isEmpty || (oldValue.text.isNotEmpty && oldValue.text.endsWith(' '))) {
          return newValue.copyWith(text: newValue.text.toUpperCase());
        }
      }
      return newValue;
    });
  }

}
