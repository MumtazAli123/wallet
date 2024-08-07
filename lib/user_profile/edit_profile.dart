// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/models/user_model.dart';

import '../app/modules/home/views/bottom_page_view.dart';
import '../app/modules/register/controllers/register_controller.dart';

class EditProfileScreen extends StatefulWidget {
  // final UserModel model;
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.put(RegisterController());

  final db = FirebaseFirestore.instance.collection('sellers');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    controller.nameController.text = sharedPreferences!.getString('name')!;
    // controller.addressController.text = sharedPreferences!.getString('address')!;
    // controller.cityController.text = sharedPreferences!.getString('city')!;
    // controller.descController.text = sharedPreferences!.getString('description')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return StreamBuilder(
        stream: db.doc(currentUserId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final UserModel model = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return _buildForm(model: model);
          }
        });
  }

  _buildForm({required UserModel model}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              '${model.name}\n'
              '${model.description}\n'
              '${model.address}\n'
              '${model.city}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: [
                  //every name of first latter capital after space
                  RegisterController.textUpperCaseTextFormatter(),
                ],
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: "Name: ${model.name}",
                  prefixIcon: const Icon(Icons.person),
                ),
                onChanged: (value) {
                  model.name = value;
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
                decoration: InputDecoration(
                  labelText: 'Vehicle Description',
                  hintText: model.description == null
                      ? 'Description: '
                      : 'Description: ${model.description}',
                  prefixIcon: const Icon(Icons.description),
                ),
                onChanged: (value) {
                  model.description = value;
                },
              ),
            ),

            //   address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: model.address == null
                      ? 'Address: '
                      : 'Address: ${model.address}',
                  prefixIcon: const Icon(Icons.location_on),
                ),
                onChanged: (value) {
                  model.address = value;
                },
              ),
            ),
            //   city
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.cityController,
                decoration: InputDecoration(
                  labelText: '${model.city}',
                  hintText: 'City: ${model.city}',
                  prefixIcon: const Icon(Icons.location_city),
                ),
                onChanged: (value) {
                  model.city = value;
                },
              ),
            ),
            SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          _saveProfile();
        },
        child: const Text('Update'),
      ),
    );
  }

  void _saveProfile() {
    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.loading,
      title: 'Updating Profile',
    );
    try {
      db.doc(currentUserId).update({
        'name': controller.nameController.text.trim(),
        'address': controller.addressController.text.trim(),
        'city': controller.cityController.text.trim(),
        'description': controller.descController.text.trim()
      }).then((value) {
        db.doc(currentUserId).collection('rating').doc(currentUserId).update({
          'name': controller.nameController.text,
        });
        // update shared preferences
        sharedPreferences!.setString('name', controller.nameController.text);
        sharedPreferences!
            .setString('address', controller.addressController.text);
        sharedPreferences!.setString('city', controller.cityController.text);
        sharedPreferences!
            .setString('description', controller.descController.text);

        QuickAlert.show(
          context: Get.context!,
          title: 'Success',
          type: QuickAlertType.success,
        );
        Get.offAll(() => const BottomPageView());
      });
    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        title: 'Error',
        type: QuickAlertType.error,
      );
    }
  }
}
