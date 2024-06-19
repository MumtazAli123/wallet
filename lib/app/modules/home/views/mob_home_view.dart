// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_model.dart';
import '../controllers/home_controller.dart';
import 'balance_card.dart';

class HomeView extends GetView {

   HomeView({super.key});


  @override
  final controller = Get.put(HomeController());
  final DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  UserModel? model;

  var isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('sellers').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          model = UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return BalanceCard(model: model);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }



}
