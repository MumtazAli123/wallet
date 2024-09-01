// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/login/controllers/login_controller.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({super.key});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final controller = Get.find<LoginController>();

  final TextEditingController _emailController = TextEditingController();

  // password reset
  Future resetPassword() async {
    try {
      // if email is not found in the database it will throw an error and catch it and show the error message
      if (_emailController.text.isNotEmpty) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        Get.back();
        QuickAlert.show(
          context: Get.context!,
          title: 'Success',
          text:
              'Password reset link sent to\n${_emailController.text}\nand check your email',
          type: QuickAlertType.success,
        );
      } else {
        QuickAlert.show(
          context: Get.context!,
          title: 'Error',
          text: 'Please enter your email address',
          type: QuickAlertType.error,
        );
      }
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(
        context: Get.context!,
        title: 'Error',
        text: 'email address not found ${e.message}',
        type: QuickAlertType.error,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = controller.email;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('sellers')
                        .where('email',
                            isEqualTo: _emailController.text.trim())
                        .get()
                        .then((value) {
                      if (value.docs.isNotEmpty) {
                        resetPassword();
                      } else {
                        QuickAlert.show(
                          context: Get.context!,
                          title: 'Error',
                          text: 'email address not found',
                          type: QuickAlertType.error,
                        );
                      }
                    });
                  });
                },
                child: Text('Send Email'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
