// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/home/views/bottom_page_view.dart';

import 'package:wallet/global/global.dart';
import 'package:wallet/models/user_model.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../../save_friends/views/save_friends_view.dart';


class SendMoneyToFriends extends StatefulWidget {
  final User? user;
  final List<UserModel> otherUser;
  final double? amount;
  const SendMoneyToFriends({super.key, this.user, required this.otherUser, this.amount});

  @override
  State<SendMoneyToFriends> createState() => _SendMoneyToFriendsState();
}

class _SendMoneyToFriendsState extends State<SendMoneyToFriends> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  final loggedInUser = UserModel();
  List<UserModel> otherUsers = [];
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel = UserModel();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetchUserData();
    fetchLoggedInUserBalance(user!.uid);
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
        UserModel user = UserModel.fromMap(userData);
        user.uid = uid;
        otherUsers.add(user);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {

          Get.to(() => SaveFriendsView(
                sellerUid: user!.uid,
                amount: loggedInUser.balance!.toDouble(),
                otherUser: otherUsers,
              ));
        },
        label: wText('Save Friends', color: Colors.white),
        icon: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(sharedPreferences!.getString('name')!),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

 Widget _buildBody(BuildContext context) {
    return Container();
 }

  void sendMoney(String text, String text2, double parse, String text3,
      {required String name,
      required String phone,
      required double amount,
      required String description}) {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection('sellers').doc(user!.uid).update({
      'balance': FieldValue.increment(-parse),
    });

    FirebaseFirestore.instance
        .collection('sellers')
        .doc(user!.uid)
        .collection('statement')
        .add({
      'name': name,
      'phone': phone,
      'amount': amount,
      'description': description,
      'type': 'debit',
      "status": "pending",
      'created_at': Timestamp.now(),
      'userId': user!.uid,
      // sender info
      'senderName': sharedPreferences!.getString('name'),
      'senderPhone': sharedPreferences!.getString('phone'),
      "category": "Send Money",
      "updated_at": Timestamp.now(),
    });

    setState(() {
      isLoading = false;
    });
  }

  void _buildShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Send Money'),
          content: Text('Are you sure you want to send money?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  sendMoney(
                    nameController.text,
                    phoneController.text,
                    double.tryParse(amountController.text) ?? 0.0,
                    descriptionController.text,
                    name: nameController.text,
                    phone: phoneController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    description: descriptionController.text,
                  );
                  _buildDialogSuccess(context);
                }
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _buildDialogSuccess(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: 'Success',
      text: 'Money sent successfully',
      type: QuickAlertType.success,
      width: 400,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // receiver
          Divider(),
          // qr code as phone number
          QrImageView(
              data: phoneController.text,
              size: 100,
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.white,

          ),

          wText("Receiver Info:"),
          Text('Name: ${nameController.text}'),
          Text('Phone: ${phoneController.text}'),
          Text('Amount: ${amountController.text}'),
          Text('Description: ${descriptionController.text}'),
          Divider(),
          // sender
          wText("Sender Info:"),
          Text('Name: ${sharedPreferences!.getString('name')}'),
          Text('Phone: ${sharedPreferences!.getString('phone')}'),

        ],
      ),
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BottomPageView(),
          ),
          (route) => false,
        );
      },
      confirmBtnText: 'Ok',
    );
  }
}
