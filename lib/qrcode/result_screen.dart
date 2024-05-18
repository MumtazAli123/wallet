// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/models/user_model.dart';

import '../app/modules/home/views/bottom_page_view.dart';
import '../app/modules/send_money/controllers/send_money_controller.dart';
import '../global/global.dart';
import '../widgets/mix_widgets.dart';

class ResultScreen extends StatefulWidget {
  final String? qrData;
  final UserModel userModel;

   const ResultScreen({super.key, required this.qrData, required this.userModel});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  final transferNominalController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  List<UserModel> otherUsers = [];

  final fb = FirebaseFirestore.instance;
  UserModel userModel = UserModel();


  @override
  void dispose() {
    transferNominalController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

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
        double userBalance =
        (double.tryParse(userData['balance'].toString()) ?? 0.0);

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
          email: userData['email'],
          phone: userData['phone'],
          uid: uid,
          balance: double.tryParse(userData['balance'].toString()) ?? 0.0,
        );
        otherUsers.add(otherUser);
      }

      setState(() {});
    }
  }


  String? qrData;
  String scanQrCode = '';
  String? qrResult = 'Not Yet Scanned';
  bool qrScanned = false;

  final controller2 = Get.put(SendMoneyController());

  // result screen




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Qr Code'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Scanned Qr Code'),
          Container(
            padding: EdgeInsets.all(10),
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: NetworkImage(widget.userModel.image!),
                      fit: BoxFit.cover,
                    ),
                  ),

                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: QrImageView(
                        data: "${widget.userModel.phone}",
                        version: QrVersions.auto,
                        size: 80.0,
                      ),
                    ),
                    wText('Name: ${widget.userModel.name}'),
                    Text('Phone: ${widget.userModel.phone}'),
                    Text('Email: ${widget.userModel.email}'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              maximumSize: Size(200, 50),
              minimumSize: Size(200, 50),

            ),
            onPressed: () {
              controller2.selectedUser.value = widget.userModel;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        textAlign: TextAlign.center,
                        'Send Money'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // send money to user
                            "Send money to ${widget.userModel.name}"),
                        SizedBox(height: 10.0),

                        TextField(
                          controller: transferNominalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.money),
                            suffixIcon: IconButton(
                              onPressed: () {
                                transferNominalController.clear();
                              },
                              icon: Icon(Icons.clear),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                            ),
                            hintText: 'Enter Amount',
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            suffixIcon: IconButton(
                              onPressed: () {
                                descriptionController.clear();
                              },
                              icon: Icon(Icons.clear),
                            ),
                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Description',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _onSubmit();
                        },
                        child: Text('Send'),
                      ),
                    ],
                  );
                },
              );

            },
            child: wText('Send Money', color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    UserModel? recipient = controller2.selectedUser.value;
    _validateField(recipient);
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
        text: 'Please select a recipient',
      );
    }
    else {
      // _otpSendFromFirebase();
      // _otpSendMoney(recipient!);
      sendMoneyToUser(recipient);
    }
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
          'type': "receive",
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
          'name': sharedPreferences!.getString('name'),
          'phone': sharedPreferences!.getString('phone') ?? 'No phone',
          'email': sharedPreferences!.getString('email') ?? 'No email',
          'type': "send",
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
            recipient.username, transferAmount, recipient.name!, recipient.phone!);
      } else {
        QuickAlert.show(
          backgroundColor: Colors.white,
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Insufficient balance to send money',
        );
        Get.snackbar('Error', 'Insufficient balance to send money',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _buildDialogWithDataReceiver(
      String? email, int transferAmount, String fullName, String phone) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text:
      // 'Money sent to $fullName\nAmount: $transferAmount\n' '\nPhone $phone\nDescription: ${descriptionController.text}',
      'Money sent to $fullName\nAmount: $transferAmount\nPhone $phone\nDescription: ${descriptionController.text}',
      textAlignment: TextAlign.start,
      onConfirmBtnTap: () {
        Get.offAll(() => BottomPageView());
      },
    );
  }


}
