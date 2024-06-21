import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/user_model.dart';

class HomeController extends GetxController {


  PageController pageController = PageController();
  GlobalKey bottomNavigationKey = GlobalKey();

  var currentIndex = 3.obs;
  var imgUrl = 'https://pay-saw.com/storage/app/public/';

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance.collection("sellers").snapshots();

  var isLoading = false.obs;
  final isMobile = false.obs;

  UserModel userModel = UserModel();

  var searchList = List.empty(growable: true).obs;
  var searchOtherUser = ''.obs;
  var isSearching = false.obs;

  var searchProduct = ''.obs;
  final searchController = TextEditingController();
  //

  var otherUsers = List.empty(growable: true).obs;
  final balance = 0.obs;

  void increment() => balance.value++;
  void decrement() => balance.value--;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);

  }

  @override
  void onReady() {
    // super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
  }


  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }


}
