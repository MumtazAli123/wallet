// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../models/user_model.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final TextEditingController nominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nominalField = TextFormField(
      controller: nominalController,
      decoration: InputDecoration(
        hintText: 'Top Up Nominal',
      ),
    );

    final topUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(242, 174, 100, 1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: double.infinity,
        onPressed: () async {
          String enteredValue = nominalController.text;
          if (enteredValue.isNotEmpty) {
            double? topUpValue = double.tryParse(enteredValue);
            if (topUpValue! < 20) {
              Get.snackbar("Error", "Minimum top up is 20");
              return;
            }
            UserModel currentUser = await fetchUserData(user!.uid);
            double currentBalance = currentUser.balance ?? 0;

            double newBalance = currentBalance + topUpValue;

            await FirebaseFirestore.instance
                .collection("users")
                .doc(user!.uid)
                .update({"balance": newBalance}).then((_) {
              setState(() {
                loggedInUser.balance = newBalance;
              });
            });

            Get.snackbar("Success", "Top up success");

            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeScreen()),
            //       (route) => false,
            // );

            Get.toNamed('/home');

                    } else {
                      Get.snackbar("Error", "Please enter a valid number");
          }
        },
        child: const Text(
          'Top Up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up Balance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              nominalField,
              SizedBox(height: 20),
              topUpButton,
            ],
          ),
        ),
      ),
    );
  }

  Future<UserModel> fetchUserData(String uid) async {
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (userSnapshot.exists) {
      return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }
}