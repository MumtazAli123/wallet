// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  void dateFilter() {
    final date = DateTime.now();
    final lastWeek = date.subtract(Duration(days: 7));
    final lastMonth = date.subtract(Duration(days: 30));
    final lastYear = date.subtract(Duration(days: 365));
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sharedPreferences!.getString('name')!),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody(){
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
                  return ListTile(
                    onTap: () {
                      isMobile(context)
                          ? _buildDetailMobile(snapshot.data!.docs[index])
                          : _buildDetailDesktop(snapshot.data!.docs[index]);
                    },
                    leading: CircleAvatar(
                      child: Text(
                        // name first letter
                          snapshot.data?.docs[index]['name'] ==
                              null
                              ? ''
                              : snapshot
                              .data?.docs[index]['name'][0]
                              .toUpperCase()),
                    ),
                    title:
                    Text(snapshot.data?.docs[index]['name']),
                    subtitle: Text(snapshot.data?.docs[index]
                    ['description']),

                    //   type and amount
                    trailing: wText(
                      snapshot.data?.docs[index]['type'] ==
                          'send'
                          ? '+${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}'
                          : '-${currencyFormat(double.parse(snapshot.data!.docs[index]['amount'].toString()))}',
                    ),
                  );
                },
              );
            }
            return wText('No Transactions');
          },
        );
  }

  isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  _buildDetailMobile(param0) {
    MediaQuery.of(context).size.width < 600;
    return QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Detail',
        text: 'Detail of the transaction',
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              'Name: ${param0['name']}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              'Type: ${param0['type'] == 'send' ? 'Received' : 'Sent'}',
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
              // description
              'Purpose: ${param0['description'] ?? 'No Description'}',
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
        ));
  }

  _buildDetailDesktop(param0) {
    MediaQuery.of(context).size.width > 600;
    return Get.defaultDialog(
      title: 'Detail',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            'Name: ${param0['name']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Amount: ${currencyFormat(double.parse(param0['amount'].toString()))}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Type: ${param0['type'] == 'send' ? 'Received' : 'Sent'}',
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
          Text(
            param0['phone'] == null
                ? 'Phone: Not Available'
                : 'Phone: ${param0['phone']}',
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
          Text(
            // description
            'Purpose: ${param0['description'] ?? 'No Description'}',
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
          Text(
            'Date: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
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
