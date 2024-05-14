// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../controllers/send_money_controller.dart';

class SendMoneyView extends StatefulWidget {
  final UserModel? loggedInUser;
  const SendMoneyView({super.key, this.loggedInUser});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  final controller = Get.put(WalletController());
  final controller2 = Get.put(SendMoneyController());

  final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  List<UserModel> otherUsers = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.loggedInUser!.name}"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.loggedInUser!.image ??
                    'https://via.placeholder.com/150'),
              ),
              title: Text('Balance'),
              subtitle: Text(widget.loggedInUser!.email ?? 'No email'),
              trailing: wText('PKR ${loggedInUser.balance ?? 0.0}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // controller: controller.searchController,
                onChanged: (value) {
                  controller2.getOtherUsers(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              // 009900
              child: Obx(() {
                if (controller2.isSearching.value) {
                  return ListView.builder(
                    itemCount: controller2.searchList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(controller2.searchList[index].image),
                        ),
                        title: Text(controller2.searchList[index].name),
                        subtitle: Text(controller2.searchList[index].phone),
                        trailing: Text(
                          controller2.searchList[index].email,
                          style: TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        onTap: () {
                          _buildDialogSendMoney(otherUsers[index]);
                          // _buildDialog();
                        },
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller2.otherUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(controller2.otherUsers[index].name),
                        subtitle: Text(controller2.otherUsers[index].email),
                        onTap: () {
                          _buildDialogSendMoney(otherUsers[index]);
                          // _buildDialog();
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void sendMoneyToUser(UserModel recipient) async {
    //   send and save statement in_out of users
    if (user != null) {
      String enteredValue = transferNominalController.text;

      double transferAmount = double.parse(enteredValue);

      if (loggedInUser.balance != null &&
          loggedInUser.balance! >= transferAmount) {
        double updatedBalance = loggedInUser.balance! - transferAmount;

        double recipientUpdatedBalance =
            (double.tryParse(recipient.balance.toString()) ?? 0.0) +
                transferAmount;
        //   update balance of sender and receiver and description of transaction
        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .update({'balance': updatedBalance});

        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .update({'balance': recipientUpdatedBalance});

        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(user!.uid)
            .collection('statement')
            .add({
          "user_id": user!.uid,
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
            recipient.username,
            transferAmount.toInt(),
            recipient.name!,
            descriptionController.text.trim(),
            recipient.phone!);
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
    } else if (recipient == null) {
      QuickAlert.show(
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please select a recipient to send money to',
      );
    } else {
      // _otpSendFromFirebase();
      // _otpSendMoney(recipient!);
      // sendMoneyToUser(recipient);
      _sureYouWantToSendMoney(recipient);
    }
  }

  void _sureYouWantToSendMoney(UserModel recipient) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      context: context,
      type: QuickAlertType.confirm,
      title: 'Send Money',
      text: 'Are you sure you want to send money to ${recipient.name}?',
      confirmBtnText: "Confirm",
      cancelBtnTextStyle: TextStyle(color: Colors.red),
      widget: Column(
        children: [
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Name: ${recipient.name}'),
            subtitle: Text('Phone: ${recipient.phone}'),
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Amount: PKR ${transferNominalController.text}'),
            subtitle: Text('Description: ${descriptionController.text}'),
          ),
        ],
      ),
      onConfirmBtnTap: () {
        Get.back();
        sendMoneyToUser(recipient);
      },
    );
  }

  void _buildDialogWithDataReceiver(String? username, int transferAmount,
      String fullName, String description, String phone) {
    QuickAlert.show(
      backgroundColor: Colors.white,
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text:
          'Money sent to $fullName\nAmount: $transferAmount\nReceiver: $username  \nPurpose: $description \nPhone $phone',
      textAlignment: TextAlign.start,
      onConfirmBtnTap: () {
        Get.toNamed('/wallet');
      },
    );
  }
}
