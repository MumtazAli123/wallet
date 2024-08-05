// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/models/user_model.dart';

import '../app/modules/register/controllers/register_controller.dart';


class EditProfileScreen extends StatefulWidget {
  final UserModel model;
  const EditProfileScreen({super.key, required this.model});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      //every name of first latter capital after space
                      RegisterController.textUpperCaseTextFormatter(),
                    ],
                    controller: controller.nameController,
                    decoration:  InputDecoration(
                      labelText: '${widget.model.name}',
                      hintText: 'Name: ${widget.model.name}',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      widget.model.name = value;
                    },
                  ),
                ),
                // address
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      //every name of first latter capital after space
                      // RegisterController.textUpperCaseTextFormatter(),
                    ],
                    controller: controller.addressController,
                    decoration:  InputDecoration(
                      labelText: '${widget.model.address}',
                      hintText: 'Address: ${widget.model.address}',
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    onChanged: (value) {
                      widget.model.address = value;
                    },
                  ),
                ),
                // city
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      //every name of first latter capital after space
                      RegisterController.textUpperCaseTextFormatter(),
                    ],
                    controller: controller.cityController,
                    decoration:  InputDecoration(
                      labelText: '${widget.model.city}',
                      hintText: 'City: ${widget.model.city}',
                      prefixIcon: const Icon(Icons.location_city),
                    ),
                    onChanged: (value) {
                      widget.model.city = value;
                    },
                  ),
                ),
                // description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      //every name of first latter capital after space
                      RegisterController.textUpperCaseTextFormatter(),
                    ],
                    controller: controller.descController,
                    decoration:  InputDecoration(
                      labelText: 'Description',
                      hintText: 'Description: ${widget.model.description}',
                      prefixIcon: const Icon(Icons.description),
                    ),
                    onChanged: (value) {
                      widget.model.description = value;
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    controller.editProfileAndUpdate();
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
