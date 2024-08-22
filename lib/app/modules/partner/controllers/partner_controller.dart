import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/user_model.dart';

class PartnerController extends GetxController {


  String image = sharedPreferences!.getString('image') ?? '';

  final count = 0.obs;

  final Rx<List> usersProfilesList = Rx<List>([]);
  List get usersProfiles => usersProfilesList.value;

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
  void increment() => count.value++;

  allProductsStream() {
    return FirebaseFirestore.instance
        .collection("products")
        .orderBy("pCreatedAt", descending: true)
        .snapshots();
  }
}
