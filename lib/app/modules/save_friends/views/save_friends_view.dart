// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/models/user_model.dart';
import 'package:wallet/widgets/text_field.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/save_friends_controller.dart';

class SaveFriendsView extends StatefulWidget {
  final String? sellerUid;
  final List<UserModel> otherUser;
  // double? amount = 0.0;
  const SaveFriendsView({super.key, this.sellerUid, required this.otherUser});

  @override
  State<SaveFriendsView> createState() => _SaveFriendsViewState();
}

class _SaveFriendsViewState extends State<SaveFriendsView> {
  final SaveFriendsController controller = Get.put(SaveFriendsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Friends'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              WTextFieldForm(
                prefixIcon: Icon(Icons.person),
                labelText: 'Name',
                controller: controller.nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              WPhoneTextFieldForm(
                labelText: 'Phone',
                controller: controller.phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter phone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              WTextFieldForm(
                prefixIcon: Icon(Icons.location_on),
                labelText: 'Address',
                controller: controller.addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              WTextFieldForm(
                prefixIcon: Icon(Icons.location_city),
                labelText: 'City',
                controller: controller.cityController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(300.0, 50.0)),
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.saveFriend(widget.sellerUid!, widget.otherUser);
                  }
                },
                child: wText('Save', color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
