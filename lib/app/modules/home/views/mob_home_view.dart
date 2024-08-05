// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../models/user_model.dart';
import '../../../../notification/notification_page.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/home_controller.dart';
import 'balance_card.dart';

class HomeView extends GetView<HomeController> {

  HomeView({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  final controller = Get.put(HomeController());
  final DateTime now = DateTime.now();
  // final user = FirebaseAuth.instance.currentUser;

  UserModel? model;

  var isLoading = false.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: Image.asset('assets/icons/icon.png').image,
          ),
        ),
        title: wText('ZubiPay'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => NotificationPage());
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              wBuildLanguageBottomSheet(context);
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
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
