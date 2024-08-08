import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ShopsController extends GetxController {
  var shops = [].obs;
  var isLoading = true.obs;
  var isShopsEmpty = false.obs;
  final user = FirebaseAuth.instance.currentUser;
  var tabController ;

  final count = 0.obs;

  var shopsList = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  void fetchShops() async {
    try {
      isLoading(true);
      var shopsData =
          await FirebaseFirestore.instance.collection("shops").get();
      if (shopsData.docs.isNotEmpty) {
        shops.assignAll(shopsData.docs);
      } else {
        isShopsEmpty(true);
      }
    } finally {
      isLoading(false);
    }
  }

  realStateStream() {
    // realState database
    return FirebaseFirestore.instance
        .collection("realState")

        .snapshots();
  }
}
