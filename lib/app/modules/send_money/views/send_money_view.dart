// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/app/modules/send_money/views/send_money_friends_view.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../../../../notification/push_notification_model.dart';
import '../../../../notification/push_notification_sys.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/send_money_controller.dart';

class SendMoneyView extends StatefulWidget {
  const SendMoneyView({super.key});

  @override
  State<SendMoneyView> createState() => _SendMoneyViewState();
}

class _SendMoneyViewState extends State<SendMoneyView> {
  // final controller1 = Get.put(WalletController());
  final controller = Get.put(SendMoneyController());
  // final formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  List<UserModel> otherUsers = [];

  final fb = FirebaseFirestore.instance;

  final TextEditingController transferNominalController =
      TextEditingController();
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String? description = '';

  UserModel userModel = UserModel();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          image: userData['image'],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => SendMoneyToFriends(
                // otherUser: otherUsers,
                amount: loggedInUser.balance!.toDouble(),
              ));
        },
        backgroundColor: Colors.green,
        label: wText('Send Money to Friends', color: Colors.white),
        icon: Icon(Icons.send, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text('Send Money'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Center(
            child: SizedBox(
              width: 550,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Card(
                  child: ListTile(
                    title: Text(otherUsers[index].name!),
                    subtitle: Text(otherUsers[index].email!),
                    trailing: Text("Pay Now"),
                    onTap: () {
                      controller.selectedUser.value = otherUsers[index];
                      _buildTransferDialog(otherUsers[index]);
                    },
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: otherUsers.length,
      ),
      // body: _buildBody(),
    );
  }

  _buildBody() {
    //   search user and send money use search bar
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            //   do not search same use
            controller: controller.searchController,
            onChanged: controller.otherUsers.isEmpty
                ? (value) {
                    controller.searchUser(value);
                  }
                : null,
            inputFormatters: [
              controller.upperCaseTextFormatter,
            ],
            decoration: InputDecoration(
              hintText: 'Search User',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Text('Searching...'),
              );
            } else {
              return ListView.builder(
                itemCount: controller.searchOtherUserList.length,
                itemBuilder: (context, index) {
                  UserModel user = UserModel.fromMap(
                      controller.searchOtherUserList[index].data()
                          as Map<String, dynamic>);
                  return ListTile(
                    title: Text(user.name!),
                    subtitle: Text(user.email!),
                    trailing: Text('Pay Now'),
                    onTap: () {
                      controller.selectedUser.value = user;
                      _buildTransferDialog(user);
                    },
                  );
                },
              );
            }
          }),
        ),
      ],
    );
  }

  _buildTransferDialog(UserModel user) {
    QuickAlert.show(
      width: 400.0,
      context: context,
      type: QuickAlertType.info,
      title: 'Send Money',
      text: 'Send money to ${user.name}',
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
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
      onConfirmBtnTap: () {
        Get.back();
        _onSubmit();
      },
      confirmBtnText: 'Send',
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
          "image": recipient.image ?? 'No image',
          "balance": updatedBalance,
          'type': "receive",
          'status': 'success',
          'transaction_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'amount': transferNominalController.text.trim(),
          //  if description is empty then set default value
          'description': descriptionController.text.trim() ?? 'No description',
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
          "image": sharedPreferences!.getString('image') ?? 'No image',
          "balance": recipientUpdatedBalance,
          'type': "send",
          'status': 'success',
          'transaction_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'amount': transferNominalController.text.trim(),
          'description': descriptionController.text.trim() ?? 'No description',
          'created_at': DateTime.now(),
        });

        setState(() {
          loggedInUser.balance = updatedBalance;
        });

        // send notification to recipient
        await sendNotificationToRecipient(recipient);

        Get.snackbar('Success', 'Money sent successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);

        _buildDialogWithDataReceiver(
            recipient.phone, transferAmount, recipient.name!);
      } else {
        QuickAlert.show(
          width: 400.0,
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

  void _onSubmit() {
    UserModel? recipient = controller.selectedUser.value;
    _validateField(recipient);
  }

  _validateField(UserModel? recipient) {
    if (transferNominalController.text.isEmpty) {
      QuickAlert.show(
        width: 400.0,
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please enter amount',
      );
    } else if (recipient == null) {
      QuickAlert.show(
        width: 400.0,
        backgroundColor: Colors.white,
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please select a recipient',
      );
    } else {
      // _otpSendFromFirebase();
      // _otpSendMoney(recipient!);
      sendMoneyToUser(recipient);
    }
  }

  void _buildDialogWithDataReceiver(
      String? phone, int transferAmount, String fullName) {
    QuickAlert.show(
      width: 400.0,
      backgroundColor: Colors.white,
      barrierDismissible: false,
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text:
          // 'Money sent to $fullName\nAmount: $transferAmount\nRecipient: $phone' +
          //     '\n\nYou will be redirected to the home page',
          'Money sent to $fullName\nAmount: $transferAmount\nPhone: $phone',
      textAlignment: TextAlign.start,
      onConfirmBtnTap: () {
        Get.offAllNamed('/home');
        // Get.offAll(() => BottomPageView());
      },
    );
  }

  // sendNotificationToRecipient(UserModel recipient) {
  //   // send notification to recipient
  //   fb.collection('sellers').doc(recipient.uid).get().then((doc) {
  //     if (doc.exists) {
  //       String? recipientDeviceToken = doc['sellerDeviceToken'];
  //
  //       if (recipientDeviceToken != null) {
  //         PNotificationModel notificationModel = PNotificationModel(
  //           title: 'Money Received',
  //           body:
  //               'You have received money from ${sharedPreferences!.getString('name')}\n'
  //               'Amount: ${transferNominalController.text}\n'
  //               'Description: ${descriptionController.text}',
  //         );
  //
  //         PushNotificationSys()
  //             .sendNotification(notificationModel, recipientDeviceToken);
  //         print(
  //             'Notification sent to recipient successfully $recipientDeviceToken');
  //       }
  //     }
  //   });
  //   notificationFormat(recipient);
  // }

  void notificationFormat(UserModel recipient) {
    // Map<String, String> headerNotification = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'key=$fcmServerToken',
    // };
    // Map bodyNotification = {
    //   'notification': {
    //     'title': 'Money Received',
    //     'body':
    //         'Dear you have received money from ${sharedPreferences!.getString('name')}\n'
    //             'Amount: ${transferNominalController.text}\n'
    //             'Description: ${descriptionController.text}',
    //   },
    //   'to': recipient.sellerDeviceToken,
    // };
    // Map dataMap = {
    //   "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //   "id": "1",
    //   "status": "done",
    //   "user_id": recipient.uid,
    // };
    // Map officialNotificationFormat = {
    //   'notification': bodyNotification,
    //   'data': dataMap,
    //   'priority': 'high',
    //   'to': recipient.sellerDeviceToken,
    // };
    //
    // http.post(
    //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
    //   headers: headerNotification,
    //   body: jsonDecode(jsonEncode(officialNotificationFormat)),
    // );
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': '$fcmServerToken',
    };
    Map bodyNotification = {
      'notification': {
        'title': 'Money Received',
        'body':
            'Dear you have received money from ${sharedPreferences!.getString('name')}\n'
            'Amount: ${transferNominalController.text}\n'
            'Description: ${descriptionController.text}',
      },
      'to': recipient.sellerDeviceToken,
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "user_id": recipient.uid,
    };
    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': recipient.sellerDeviceToken,
    };

    http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerNotification,
      body: jsonDecode(jsonEncode(officialNotificationFormat)),
    );
  }

  sendNotificationToRecipient(UserModel recipient) {
    // send notification to recipient
    fb.collection('sellers').doc(recipient.uid).get().then((doc) {
      if (doc.exists) {
        String? recipientDeviceToken = doc['sellerDeviceToken'];

        if (recipientDeviceToken != null) {
          PNotificationModel notificationModel = PNotificationModel(
            title: 'Money Received',
            body:
                'You have received money from ${sharedPreferences!.getString('name')}\n'
                'Amount: ${transferNominalController.text}\n'
                'Description: ${descriptionController.text}',
          );

          PushNotificationSys()
              .sendNotification(notificationModel, recipientDeviceToken);
          if (kDebugMode) {
            print(
              'Notification sent to recipient successfully $recipientDeviceToken');
          }
        }
      }
    });
    notificationFormat(recipient);

  }
}
