// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../controllers/send_money_controller.dart';

class SendMoneyView extends StatefulWidget {
  final UserModel? loggedInUser;
  const SendMoneyView({super.key, this.loggedInUser});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {

  final controller = Get.put(SendMoneyController());
  final _formKey = GlobalKey<FormState>();

  final  otherUsers = List<UserModel>.empty(growable: true);
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  UserModel? recipient;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.loggedInUser!.name}"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // controller: controller.searchController,
                onChanged: (value) {
                  controller.getOtherUsers(value);
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
              child: Obx(() {
                if (controller.isSearching.value) {
                  return ListView.builder(
                    itemCount: controller.searchList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              controller.searchList[index].image),
                        ),
                        title: Text(controller.searchList[index].name),
                        subtitle: Text(controller.searchList[index].phone),
                        trailing: Text(controller.searchList[index].email,
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis
                            ,maxLines: 1,),
                        onTap: () {
                            _buildDialogSendMoney();
                          // _buildDialog();
                        },
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.otherUsers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(controller.otherUsers[index].name),
                        subtitle: Text(controller.otherUsers[index].email),
                        onTap: () {
                          _buildDialogSendMoney();
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


  void _buildDialogSendMoney() {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: 'Send Money',
      // text: 'Enter amount to send',
      content: SingleChildScrollView(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: controller.transferNominalController,
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
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            _validateField(recipient!);
          },
          child: Text('Send'),
        ),
      ],
    );
  }



  _validateField(UserModel recipient) {
    if (controller.transferNominalController.text.isEmpty) {
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
      // sendMoneyToUser(recipient);
      _buildSureDialog(recipient);
    }
  }

  void _buildSureDialog(UserModel recipient) {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: 'Send Money',
      content: Column(
        children: [
          Text('Are you sure you want to send money to ${recipient.name}'),
          SizedBox(height: 10.0),
          Text('Amount: ${controller.transferNominalController.text}'),
          SizedBox(height: 10.0),
          Text('Description: ${controller.descriptionController.text}'),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            sendMoneyToUser(recipient);
          },
          child: Text('Send'),
        ),
      ],
    );
  }

  void sendMoneyToUser(UserModel recipient) async {
    //   send and save statement in_out of users
    if (user != null) {
      String enteredValue = controller.transferNominalController.text;

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
          'amount': controller.transferNominalController.text.trim(),
          'description': controller.descriptionController.text.trim(),
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
          'amount': controller.transferNominalController.text.trim(),
          'description': controller.descriptionController.text.trim(),
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
            recipient.username, transferAmount, recipient.name!, controller.descriptionController.text.trim());
      } else {
        Get.snackbar('Error', 'Insufficient balance to send money',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
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


}

