import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';

class HomeController extends GetxController {
  final nameController = TextEditingController();

  final count = 0.obs;
  final name = ''.obs;
  final email = ''.obs;
  final image = ''.obs;
  final phone = ''.obs;
  final balance = ''.obs;

  final db = FirebaseFirestore.instance;


  var articleList = [].obs;

  var isRefresh = false.obs;
  var isLoading = false.obs;



  void article() async {
    var snapshot =
        await db.collection('sellers').doc(uid).get();

    name.value = snapshot.data()?['name'] ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    article();
  }



  void increment() => count.value++;


  void streamArticle() {
    db.collection('sellers').doc(uid).snapshots().listen((event) {
      name.value = event.data()?['name'] ?? '';
    });
  }

  String? getArticleTitle() {
    return 'Title';
  }

  void addArticle(String title) {
    db.collection('sellers').doc(uid).set({
      'name': title,
    }).then((value) {
      article();
    });
  }

  void updateArticle(Map<String, String> map) {
    db.collection('sellers').doc(uid).update(map).then((value) {
      article();
    });
  }

  void updateSellerName({required String name}) {
    QuickAlert.show(
        context: Get.context!,
        title: 'Updating',
        text: 'Please wait...',
        type: QuickAlertType.info,
    );
  }

}
