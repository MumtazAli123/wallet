// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/app/modules/home/views/bottom_page_view.dart';
import 'package:wallet/app/modules/login/views/login_view.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/statement_controller.dart';

class StatementView extends StatefulWidget {
  final UserModel? loggedInUser;
  const StatementView({super.key, this.loggedInUser});

  @override
  State<StatementView> createState() => _StatementViewState();
}

class _StatementViewState extends State<StatementView> {
  final controller = Get.put(StatementController());
  String? uid = fAuth.currentUser!.uid;
  final user = fAuth.currentUser;

  final date = DateTime.now();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  //   isLoading = true load CircularProgressIndicator for 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(() => BottomPageView());
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock_sharp),
            onPressed: () {
              fAuth.signOut().then((value) {
                Get.offAll(() => LoginView());
              });
            }
          ),
        ],
        title: Text(sharedPreferences!.getString('name')!),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return isLoading == true
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sellers')
          .doc(sharedPreferences?.getString('uid'))
          .collection('statement')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Card(
                  elevation: 0.5,
                  child: ListTile(
                    onTap: () {
                      _buildDetailMobile(snapshot.data!.docs[index]);
                    },
                    leading: CircleAvatar(
                      child: Text(
                        // name first letter
                          snapshot.data?.docs[index]['name'] == null
                              ? ''
                              : snapshot.data?.docs[index]['name'][0]
                              .toUpperCase()),
                    ),
                    title: Text(snapshot.data?.docs[index]['name']),
                    subtitle: Text(
                        'Time: ${GetTimeAgo.parse(DateTime.parse(snapshot.data!.docs[index]['created_at'].toDate().toString()), locale: 'en')}'),

                    //   type and amount
                    trailing: wText(
                      snapshot.data?.docs[index]['type'] == 'send'
                          ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                          : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                    ),
                  ),
                ),
              );
            },
          );
        }
        return wText('No Transactions');
      },
    );
  }

  _buildDetailMobile(param0) {
    MediaQuery.of(context).size.width < 600;
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.values[3],
      title: "${param0['name'.tr]}",
      text: 'Detail of the transaction',
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          wText(
            'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}',
            color: Colors.black,
          ),
          Text(
            'Type: ${param0['type'] == 'send' ? 'Credit' : 'Debit'}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            // description
            'Purpose: ${param0['description'] ?? 'No Description'}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            param0['phone'] == null
                ? 'Phone: Not Available'
                : 'Phone: ${param0['phone']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            'Time: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            //   gate date time just date and time only without timezone
            'Date: ${DateTime.parse(param0['created_at'].toDate().toString()).toString().substring(0, 16)}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          )
        ],
      ),
      cancelBtnText: 'Close',
      //     cancel btn false
      showConfirmBtn: false,
    );
  }

  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
