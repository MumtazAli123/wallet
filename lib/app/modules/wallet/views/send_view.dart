// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:wallet/global/global.dart';

import '../../../../models/user_model.dart';

class SendView extends StatefulWidget {
  UserModel? recipient;
  SendView({super.key, this.recipient});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final controller = Get.put(WalletController());

  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  List<UserModel> otherUsers = [];

  // search and save user list from firebase firestore


  final fb = FirebaseFirestore.instance;

  final TextEditingController transferNominalController =
  TextEditingController();
  final descriptionController = TextEditingController();

  UserModel userModel = UserModel();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    if (user != null) {
      fetchLoggedInUserBalance(user!.uid);
    }
  }

  Future<void> fetchLoggedInUserBalance(String uid) async {
    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('sellers').doc(uid);

    DocumentSnapshot docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? userData =
      docSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        double userBalance = userData['balance'] ?? 0;

        setState(() {
          loggedInUser.balance = userBalance;
        });
      }
    }
  }

  Future<void> fetchUserData() async {
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('sellers');

    QuerySnapshot querySnapshot = await usersCollection.get();

    otherUsers.clear();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> userData =
      documentSnapshot.data() as Map<String, dynamic>;

      String uid = documentSnapshot.id;

      if (uid != user?.uid) {
        UserModel otherUser = UserModel(
          username: userData['name'],
          name: userData['name'],
          uid: uid,
          balance: userData['balance'] ?? 0,
        );
        otherUsers.add(otherUser);
      }

      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipient?.name  ?? 'Send Money'.substring(0, 1).toUpperCase() + 'Send Money'.substring(1)),
      ),
      // body: ListView(
      //   children: otherUsers.map((recipient) {
      //     return Container(
      //       margin: EdgeInsets.all(20),
      //       height: 100,
      //       width: double.infinity,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(5),
      //         color: Color.fromRGBO(245, 152, 53, 0.498),
      //       ),
      //       child: Padding(
      //         padding: EdgeInsets.all(25),
      //         child: Column(
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Text(
      //                   "${recipient.username}",
      //                   style: TextStyle(
      //                       fontSize: 18, fontWeight: FontWeight.bold),
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     _buildDialogSendMoney(recipient);
      //                   },
      //                   child: Text('Send Money'),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   }).toList(),
      // ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(20),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(245, 152, 53, 0.498),
          ),
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${otherUsers[index].name}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _buildDialogSendMoney(otherUsers[index]);
                      },
                      child: Text('Send Money'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
        itemCount: otherUsers.length,
      ),
    );
  }

  void sendMoneyToUser(UserModel recipient) async {
    //   send and save statement in_out of users
    if (user != null) {
      String enteredValue = transferNominalController.text;

      int transferAmount = int.tryParse(enteredValue) ?? 0;

      if (loggedInUser.balance != null &&
          loggedInUser.balance! >= transferAmount) {
        double updatedBalance = loggedInUser.balance! - transferAmount;

        double recipientUpdatedBalance = (recipient.balance!) + transferAmount;
        //   update balance of sender and receiver and description of transaction
        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .update({'balance': updatedBalance});

        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(recipient.uid)
            .update({'balance': recipientUpdatedBalance});

        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .collection('statement')
            .add({
          "user_id": recipient.uid,
          'name': recipient.name,
          'phone': recipient.phone ?? 'No phone',
          'email': recipient.email ?? 'No email',
          'type': "send",
          'amount': transferNominalController.text.trim(),
          'description': descriptionController.text.trim(),
          'created_at': DateTime.now(),

        });

        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(recipient.uid)
            .collection('statement')
            .add({
          "user_id": user!.uid,
          'name': sharedPreferences?.getString('name'),
          'phone': sharedPreferences?.getString('phone') ?? 'No phone',
          'email': sharedPreferences?.getString('email') ?? 'No email',
          'type': "receive",
          'amount': transferNominalController.text.trim(),
          'description': descriptionController.text.trim(),
          'created_at': DateTime.now(),
        });

        setState(() {
          loggedInUser.balance = updatedBalance;
        });

        Get.snackbar('Success', 'Money sent successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);

        _buildDialogWithDataReceiver(
            recipient.username, transferAmount, recipient.name!, descriptionController.text.trim());
      } else {
        Get.snackbar('Error', 'Insufficient balance to send money',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _buildDialogSendMoney(UserModel recipient) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      context: context,
      type: QuickAlertType.info,
      title: 'Send Money',
      // text: 'Enter amount to send',
      textAlignment: TextAlign.center,
      widget: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: transferNominalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
            ),
            SizedBox(height: 2.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description',
              ),
            ),
          ],
        ),
      ),
      onConfirmBtnTap: () {
        Get.back();
        _validateField(recipient);
      },
    );
  }

  _validateField(UserModel? recipient) {
    if (transferNominalController.text.isEmpty) {
      QuickAlert.show(
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please enter amount',
      );
    }else if (recipient == null) {
      QuickAlert.show(
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please select a recipient to send money to',
      );
    }
    else {
      // _otpSendFromFirebase();
      // _otpSendMoney(recipient!);
      sendMoneyToUser(recipient);
    }
  }


  void _buildDialogWithDataReceiver(
      String? username, int transferAmount, String fullName, String description) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text:
      'Money sent to $fullName\nAmount: $transferAmount\nReceiver: $username \nPurpose: $description',
      textAlignment: TextAlign.start,
      onConfirmBtnTap: () {
        Get.toNamed('/wallet');
      },
    );
  }


  void _buildDialog(DocumentSnapshot<Object?> documentSnapshot) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      context: context,
      type: QuickAlertType.confirm,
      title: 'Transaction Details',
      text: 'You ${documentSnapshot['type']} PKR: ${documentSnapshot['amount']}',
      widget: Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Name: ${documentSnapshot['name']}'),
            subtitle: Text('Phone: ${documentSnapshot['phone']}'),
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Amount: PKR ${documentSnapshot['amount']}'),
            subtitle: Text('You ${documentSnapshot['type']} PKR ${documentSnapshot['amount']}'),
          ),
        ],
      ),
    );
  }

}