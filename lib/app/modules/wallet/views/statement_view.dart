// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/wallet/controllers/wallet_controller.dart';

import '../../../../models/user_model.dart';

class StatementView extends StatefulWidget {
  UserModel userModel;
  StatementView({super.key, required this.userModel});

  @override
  State<StatementView> createState() => _StatementViewState();
}

class _StatementViewState extends State<StatementView> {
  final controller = Get.put(WalletController());
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;

  @override
  void initState() {
    controller.statementInOut();
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userModel.name}'s Statement"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('sellers')
          .doc(user!.uid)
          .collection('statement')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No transaction yet"),
          );
        }
        return ListView.builder(
          // new transaction will be at the top
          // reverse: true,
          // controller: ScrollController()..jumpTo(0),
          clipBehavior: Clip.none,

          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                _buildDialog(snapshot.data!.docs[index]);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  snapshot.data!.docs[index]['name']
                      .toString()[0]
                      .toUpperCase(),
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(snapshot.data!.docs[index]['name'].toString()),
              subtitle: Text(snapshot.data!.docs[index]['type'].toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    snapshot.data!.docs[index]['type'] == "send"
                        ? "- PKR ${snapshot.data!.docs[index]['amount']}"
                        : "+ PKR ${snapshot.data!.docs[index]['amount']}",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _buildDialog(QueryDocumentSnapshot<Object?> doc) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "Transaction Details",
      // text: "You ${doc['type']}, PKR: ${doc['amount']}",
      // you sent or received
      text: "You ${doc['type']} PKR: ${doc['amount']}",
      widget: Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Name: ${doc['name']}"),
            subtitle: Text("Phone: ${doc['phone']}"),
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text("Amount: PKR ${doc['amount']}"),
            // subtitle: Text("You: ${doc['type']}"),
            // you sent or received
            subtitle: Text("You ${doc['type']} PKR ${doc['amount']}"),

          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
              GetTimeAgo.parse(
                  DateTime.parse("${doc['created_at'].toDate()}".toString()),
                  locale: 'en'),
            ),
            // time not seconds show
            subtitle: Text(
              "${doc['created_at'].toDate()}".toString().substring(0, 19),
            ),
          ),
        ],
      ),
      confirmBtnText: "Close",
    );
  }
}
