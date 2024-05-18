import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/seller_model.dart';

class WalletController extends GetxController {
  final transferNominalController = TextEditingController();
  final descriptionController = TextEditingController();

  final totalBalance = 0.obs;

  var addMoney = 0.0.obs;
  var sendMoney = 0.0.obs;

  var type = ''.obs;

  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var balance = ''.obs;

  var isRefresh = false.obs;

  var statementInOutList = [].obs;

  var isLoading = false.obs;

  final db = FirebaseFirestore.instance;
  SellerModel userModel = SellerModel();

  var incomeList = [].obs;



  void increment() => totalBalance.value++;
  void decrement(double parse) {
    if (totalBalance.value > 0) {
      totalBalance.value--;
    }
  }

  @override
  void onClose() {}





  void addStatementInOut() async {
    await db.doc('statement').collection('in_out').add({
      'type': type.value,
      'amount': addMoney.value,
      'created_at': DateTime.now(),
    });
    refresh();
  }

  void sendStatementInOut() async {
    // save other user data
    await db.doc('sellers').collection('statement').add({
      "user_id": userModel.uid,
      'name': userModel.name,
      'phone': userModel.phone,
      'email': userModel.email,
      'type': "send",
      'amount': transferNominalController.text.trim(),
      'description': descriptionController.text.trim() == ''
          ? 'No description'
          : userModel.name,
      'created_at': DateTime.now(),
    });
    refresh();
  }

  void incomeStatementInOut() async {
    await db.doc('sellers').collection('statement').add({
      "user_id": userModel.uid,
      'name': userModel.name,
      'phone': userModel.phone,
      'type': 'income',
      'amount': addMoney.value,
      'description': descriptionController.text.trim() == ''
          ? 'No description'
          : userModel.name,
      'created_at': DateTime.now(),
    });
    refresh();
  }

  @override
  void refresh() {
    isRefresh.value = !isRefresh.value;
  }

  void clear() {
    addMoney.value = 0.0;
    sendMoney.value = 0.0;
  }

  void clearType() {
    type.value = '';
  }

  void clearAll() {
    clear();
    clearType();
  }

  void streamArticle() {
    db.collection('sellers').doc(uid).snapshots().listen((event) {
      name.value = event.data()?['name'] ?? '';
      phone.value = event.data()?['phone'] ?? '';
      email.value = event.data()?['email'] ?? '';
      balance.value = event.data()?['balance'] ?? '';
    });
  }

}
