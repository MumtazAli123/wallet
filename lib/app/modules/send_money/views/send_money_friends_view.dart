// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/global/global.dart';

import 'package:wallet/models/user_model.dart';
import 'package:wallet/provider/address_changer.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../../../../models/address_model.dart';
import '../../save_friends/controllers/save_friends_controller.dart';
import '../../save_friends/views/save_friends_view.dart';
import '../controllers/send_money_controller.dart';

class SendMoneyToFriends extends StatefulWidget {
  final User? user;
  // final List<UserModel> otherUser;
  final double? amount;
  final String? sellerUid;
  const SendMoneyToFriends({super.key, this.user, this.amount, this.sellerUid});

  @override
  State<SendMoneyToFriends> createState() => _SendMoneyToFriendsState();
}

class _SendMoneyToFriendsState extends State<SendMoneyToFriends> {
  final controller = Get.put(SendMoneyController());
  final saveController = Get.put(SaveFriendsController());

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<UserModel> otherUsers = [];

  final fb = FirebaseFirestore.instance;

  final TextEditingController transferNominalController =
      TextEditingController();
  final descriptionController = TextEditingController();

  String? description = '';
  double? amount;
  String? name = '';
  String? phone = '';
  String? address = '';
  String? city = '';
  String? addressId = '';

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
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => SaveFriendsView(
                sellerUid: user!.uid,
                // amount: loggedInUser.balance!.toDouble(),
                otherUser: otherUsers,
              ));
        },
        label: wText('Add Friends', color: Colors.white),
        icon: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
            '${sharedPreferences!.getString('name')}, ${loggedInUser.balance}'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        //   query
        //   model
        //   design
        Consumer<AddressChanger>(builder: (context, address, child) {
          return Flexible(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('sellers')
                    .doc(user!.uid)
                    .collection('friends')
                    .snapshots(),
                builder: (context, AsyncSnapshot dataSnapShot) {
                  // if data
                  if (dataSnapShot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: wText(
                      'Loading...',
                    ));
                  } else {
                    return ListView.builder(
                      itemCount: dataSnapShot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            dataSnapShot.data.docs[index];
                        AddressModel addressModel = AddressModel.fromJson(
                            documentSnapshot.data() as Map<String, dynamic>);
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Card(
                            child: Slidable(
                              endActionPane:
                                  ActionPane(motion: ScrollMotion(), children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    saveController.deleteFriend(
                                        documentSnapshot.id);
                                  },
                                  label: 'Delete',
                                  icon: Icons.delete,
                                  flex: 2,
                                  backgroundColor: Colors.red,

                                ),
                              ]),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(addressModel.name![0]),
                                ),
                                title: Text("Name: ${addressModel.name}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Phone: ${addressModel.phone}'),
                                    Text("City: ${addressModel.fCity}"),
                                    Text(addressModel.address!),
                                  ],
                                ),
                                trailing: address.count == index
                                    ? Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.green),
                                        ),
                                      ),
                                onTap: () {
                                  // address.showSelectedFriends(index);
                                  Provider.of<AddressChanger>(context,
                                          listen: false)
                                      .showSelectedFriends(index);
                                  // _buildTransMoneyDialog(context, addressModel);
                                  controller.selectedUser.value =
                                      otherUsers[index];
                                  saveController.sendMoneyToFriends(
                                       addressModel);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          );
        }),
      ],
    );
  }

  void _buildTransferDialog(UserModel otherUser) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transfer Money'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: transferNominalController,
                decoration: InputDecoration(
                  hintText: 'Nominal',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
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
                if (transferNominalController.text.isNotEmpty) {
                  amount = double.tryParse(transferNominalController.text);
                  description = descriptionController.text;
                  if (amount! > loggedInUser.balance!) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: 'Insufficient balance');
                  } else {
                    _transferMoney(otherUser);
                  }
                } else {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: 'Please fill the form');
                }
              },
              child: Text('Transfer'),
            ),
          ],
        );
      },
    );
  }

  void _transferMoney(UserModel otherUser) {
    double newBalance = loggedInUser.balance! - amount!;
    double otherUserNewBalance = otherUser.balance! + amount!;

    firestore.collection('sellers').doc(user!.uid).update({
      'balance': newBalance,
    });

    firestore.collection('sellers').doc(otherUser.uid).update({
      'balance': otherUserNewBalance,
    });

    firestore
        .collection('sellers')
        .doc(user!.uid)
        .collection('transactions')
        .add({
      'amount': amount,
      'description': description,
      'date': DateTime.now(),
      'type': 'debit',
    });

    firestore
        .collection('sellers')
        .doc(otherUser.uid)
        .collection('transactions')
        .add({
      'amount': amount,
      'description': description,
      'date': DateTime.now(),
      'type': 'credit',
    });

    _buildQuickAlert(otherUser);
  }

  void _buildQuickAlert(addFriend) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Transfer success',
      width: 200,
      widget: Column(
        children: [
          // name
          Text('You have transferred $amount to ${addFriend.name}'),
          // phone
          Text('Description: $description'),
          // address
          Text('Your new balance is $address'),
          Text('Your new balance is ${loggedInUser.balance! - amount!}'),
        ],
      ),
      onConfirmBtnTap: () {
        Get.offAllNamed('/home');
      },
    );
  }
}
