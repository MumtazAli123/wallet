import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StatementController extends GetxController {
  //TODO: Implement StatementController

  final count = 0.obs;
  var searchList = List.empty(growable: true).obs;
  var searchOtherUser = ''.obs;
  var isSearching = false.obs;
  var query = ''.obs;

  var statementList = List.empty(growable: true).obs;




  void increment() => count.value++;

  void getStatement(String query, {required date, String? uid}) {
    // sellers
    searchList.clear();
    searchOtherUser.value = query;
    if (query.isNotEmpty) {
      isSearching.value = true;
      FirebaseFirestore.instance
          .collection('sellers')
          .where('name', isEqualTo : query)
          .get()
          .then((value) => searchList.value= value.docs);
    } else {
      isSearching.value = false;
    }

  }
}
