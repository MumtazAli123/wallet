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

  void initState() {
    super.initState();
    controller.getStatement(
        widget.loggedInUser!.name.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.loggedInUser!.name}"),
        centerTitle: true,
      ),
      body:  StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('sellers')
              .doc(user!.uid)
              .collection('statement')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildStatementItem(snapshot.data!.docs[index]);
              },
            );
          }),
    );
  }
  _buildStatementItem(param0) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 450,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {
            _buildDetailDialog(param0);
          },
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              "${param0['name'][0]}",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            "${param0['name']}",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            GetTimeAgo.parse(
                DateTime.parse(param0['created_at'].toDate().toString()),
                locale: 'en'),
          ),
          trailing: Column(
            children: [
              Text(
                "${param0['type'] == 'send' ? '-' : '+'} ${currencyFormat(double.parse(param0['amount'].toString()))}",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                param0['type'] == 'send' ? 'Sent' : 'Received',
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildDetailDialog(param0) async {
    // is mobile or tablet or desktop
    return isMobile(context)
        ? _buildDetailMobile(param0)
        : _buildDetailDesktop(param0);
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
              'Type: ${param0['type']}',
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
            'Type: ${param0['type']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            param0['phone'] == null
                ? 'Phone: Not Available'
                : 'Phone: ${param0['phone']}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            // description
            'Purpose: ${param0['description'] ?? 'No Description'}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Date: ${GetTimeAgo.parse(DateTime.parse(param0['created_at'].toDate().toString()), locale: 'en')}',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
  currencyFormat(double? balance) {
    // as per thousand separator
    return balance?.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }



}
