// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:screenshot/screenshot.dart';

import '../../../../models/user_model.dart';

class DigitalWalletView extends StatefulWidget {
  UserModel? model;
   DigitalWalletView({super.key, this.model });

  @override
  State<DigitalWalletView> createState() => _DigitalWalletViewState();
}

class _DigitalWalletViewState extends State<DigitalWalletView> {
  final ScreenshotController screenshotController = ScreenshotController();

  bool isLoading = false;
  final Dio dio = Dio();
  final DateTime now = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;

  UserModel? model;

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await getUserData();

  }


  Future<void> getUserData() async {
    // get data from firebase
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .get();
    model = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // get user data
    getUserData();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    // digital wallet design new one new look
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: _refresh,
            child: Screenshot(
              controller: screenshotController,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  _buildBalanceCard(),
                  SizedBox(height: 20.0),
                  _buildButton(),
                  SizedBox(height: 20.0),
                  _buildTransactionCard(),
                  SizedBox(height: 20.0),
                  _buildFooter(),
                ],
              ),
            ),
          );
  }

  _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance'.tr,
                style: GoogleFonts.gabriela(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // MixWidgets.buildAvatar(model!.image, 30.0),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // '₦${model!.balance}',
                "Rs: ${currencyFormat(double.parse(model!.balance.toString()))}"
                    .tr,
                style: GoogleFonts.gabriela(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Send Money'.tr),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Add Money'.tr),
        ),
      ],
    );
  }

  _buildFooter() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Powered by ZubiPay Digital Wallet'.tr,
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '© ${now.year} - ZubiPay Digital Wallet.',
            style: GoogleFonts.poppins(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  _buildTransactionCard() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'View All'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: MixWidgets.buildAvatar(model!.image, 30.0),
                title: Text('Payment from ${model!.name}'),
                subtitle: Text('₦${model!.balance}'),
                trailing: Text('12:00 PM'),
              );
            },
          ),
        ],
      ),
    );
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

class MixWidgets {
  static buildAvatar(String? image, double size) {
    return CircleAvatar(
      radius: size,
      backgroundImage: NetworkImage(image!),
    );
  }
}
