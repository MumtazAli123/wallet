// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/models/user_model.dart';

import '../controllers/save_friends_controller.dart';

class SaveFriendsView extends StatefulWidget {
 final String? sellerUid;
  final List<UserModel> otherUser;
  double? amount = 0.0;
   SaveFriendsView({super.key, this.sellerUid, required this.otherUser, this.amount});

  @override
  State<SaveFriendsView> createState() => _SaveFriendsViewState();
}

class _SaveFriendsViewState extends State<SaveFriendsView> {
  final SaveFriendsController controller = Get.put(SaveFriendsController());

  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Text('Save Friends'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                    labelText: 'Name'
                ),

                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: controller.phoneController,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                    labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter phone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: controller.addressController,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                    labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: controller.cityController,
                decoration:  InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                    labelText: 'City Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter city name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.saveFriend(
                      _auth.currentUser!.uid,
                      widget.otherUser,
                    );
                  }
                },
                child:  Text('Save'),
              ),
            ],
          ),
        ),
    ),
    );
  }
}
