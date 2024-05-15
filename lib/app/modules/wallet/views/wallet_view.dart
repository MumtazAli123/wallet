// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:wallet/app/modules/wallet/views/send_view.dart';
import 'package:wallet/app/modules/wallet/views/topup_view.dart';

import '../../../../models/user_model.dart';
import '../../../../widgets/currency_format.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/bottom_page_view.dart';

class WalletView extends StatefulWidget {
  UserModel? loggedInUser;
  WalletView({super.key, this.loggedInUser});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(() => TopUpView());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   '₦${currencyFormat(widget.loggedInUser!.balance)}',
                    //   style: GoogleFonts.roboto(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last Transaction',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   '₦${currencyFormat(widget.loggedInUser!.lastTransaction)}',
                    //   style: GoogleFonts.roboto(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('statements')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.docs.isEmpty) {
                  return Center(
                    child: Text('No transactions yet'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var transaction = snapshot.data.docs[index];
                    return ListTile(
                      title: Text(transaction['type']),
                      subtitle: Text(
                        '${currencyFormat(transaction['amount'])} - ${GetTimeAgo.parse(transaction['timestamp'].toDate().millisecondsSinceEpoch)}',
                      ),
                      trailing: Text(
                        '₦${currencyFormat(transaction['balance'])}',
                        style: TextStyle(
                          color: transaction['type'] == 'Debit'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  currencyFormat(double? balance) {
    return balance!.toStringAsFixed(2);
  }
}
