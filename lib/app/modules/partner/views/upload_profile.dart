// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';

import 'package:get/get.dart';
import 'package:getwidget/shape/gf_badge_shape.dart';
import 'package:intl/intl.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/widgets/mix_widgets.dart';

import '../../../../utils/translation.dart';
import '../controllers/partner_controller.dart';

class UploadProfile extends StatefulWidget {
  const UploadProfile({super.key});

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  final PartnerController controller = Get.put(PartnerController());

  bool isGender = false;
  void currentAgeToDob() {
    controller.dobController.addListener(() {
      if (controller.dobController.text.isNotEmpty) {
        DateTime dob =
        DateFormat('dd MMM yyyy').parse(controller.dobController.text);
        DateTime now = DateTime.now();
        Duration diff = now.difference(dob);
        controller.age = (diff.inDays / 365).floor();
      }
    });
  }

  void validateAndUploadForm() {
    if (controller.profileImage == null) {
      wGetSnackBar("Image", "Please select an image", color: Colors.red);
      return;
    }if (controller.dobController.text.isEmpty) {
      wGetSnackBar("Date of Birth", "Please select your date of birth",
          color: Colors.red);
      return;
    } else {
      controller.currentScreen.value = 1;
    }
  }

  void validateLifestyleFormScreen() {
    if (controller.incomeController.text.isEmpty) {
      wGetSnackBar("Income", "Please enter your income", color: Colors.red);
      return;
    } else if (controller.bioController.text.isEmpty) {
      wGetSnackBar("Bio", "Please enter your bio", color: Colors.red);
      return;
    } else {
      controller.currentScreen.value = 2;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.pickedFile = Rx<File?>(null);
    currentAgeToDob();
    if(controller.genderValue == null){
      isGender = true;
    }else{
      isGender = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Obx(() {
          if (controller.currentScreen.value == 0) {
            return bioFormScreen();
          } else if (controller.currentScreen.value == 1) {
            return lifestyleFormScreen();
          } else if (controller.currentScreen.value == 2) {
            return profileScreen();
          }else{
            return Container();
          }
        }),
      ),
    );
  }

  Widget bioFormScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Utils.buildAppBar(
            title: '${sharedPreferences!.getString('name')} Profile',
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          SizedBox(height: 20),
          Utils.buildImagePicker(
            image: controller.profileImage,
            onTap: () => controller.selectImage(),
            onRemove: () => controller.removeImage(),
          ),
          // gender
          _genderWidget(),
          SizedBox(height: 20),
          // date of birth
          _buildDobWidget(),
          SizedBox(height: 20),
          // age to date  - dob to age years old
          wText("Age: ${controller.age}, years old", color: Colors.blue),
          //   button
          wCustomButton(
              color: Colors.green,
              width: 250,
              text: 'Next',
              icon: Icons.arrow_forward,
              onPressed: () {
                validateAndUploadForm();
              }),
        ],
      ),
    );
  }

  Widget lifestyleFormScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Utils.buildAppBar(
            title: 'Lifestyle',
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => controller.currentScreen.value = 0,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.incomeController,
            decoration: InputDecoration(
              labelText: 'Income',
              hintText: 'Enter your income',
              suffixIcon: IconButton(
                onPressed: () => controller.incomeController.clear(),
                icon: Icon(Icons.clear),
              ),
              prefixIcon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ).w(350),
          SizedBox(height: 20),
          TextField(
            controller: controller.bioController,
            decoration: InputDecoration(
              labelText: 'Bio',
              hintText: 'Enter your bio',
              suffixIcon: IconButton(
                onPressed: () => controller.bioController.clear(),
                icon: Icon(Icons.clear),
              ),
              prefixIcon: Icon(Icons.info),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ).w(350),
          SizedBox(height: 20),
          wCustomButton(
              color: Colors.green,
              width: 250,
              text: 'Next',
              icon: Icons.arrow_forward,
              onPressed: () {
                validateLifestyleFormScreen();
              }),
        ],
      ),
    );
  }

  Widget profileScreen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Utils.buildAppBar(
            title: 'Profile',
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => controller.currentScreen.value = 1,
            ),
          ),
          SizedBox(height: 20),
          Utils.buildImagePicker(
            image: controller.profileImage,
            onTap: () => controller.selectImage(),
            onRemove: () => controller.removeImage(),
          ),
          SizedBox(height: 20),
          // name
      Padding(

        padding: const EdgeInsets.all(8.0),
        child: Table(

          children: [
          //   name
          TableRow(

            children: [
              aText('Name', color: Colors.blue),
              aText(sharedPreferences!.getString('name') ?? '', color: Colors.green),
            ],
          ),
          //   email
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            children: [
              aText('Email', color: Colors.blue),
              aText(sharedPreferences!.getString('email') ?? '', color: Colors.green),
            ],
          ),
          //   phone
          TableRow(
            children: [
              aText('Phone', color: Colors.blue),
              aText(sharedPreferences!.getString('phone') ?? '', color: Colors.green),
            ],
          ),
          // age
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            children: [
              aText('Age', color: Colors.blue),
              aText('${controller.age} years old', color: Colors.green),
            ],
          ),
          // dob
          TableRow(
            children: [
              aText('Date of Birth', color: Colors.blue),
              aText(controller.dobController.text, color: Colors.green),
            ],
          ),
          // income
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            children: [
              aText('Income', color: Colors.blue),
              aText(controller.incomeController.text, color: Colors.green),
            ],
          ),
          // bio
            TableRow(
              children: [
                aText('Bio', color: Colors.blue),
                aText(controller.bioController.text, color: Colors.green),
              ],
            ),



          ],
        ),
      ),
          SizedBox(height: 20
      ),

          SizedBox(height: 20),
          //   button
          wCustomButton(
              color: Colors.green,
              width: 250,
              text: 'Save Profile',
              icon: Icons.save,
              onPressed: () {
                controller.createNewUserAccount();
              }),
        ],
      ),
    );

  }


  _genderWidget() {
    return Center(
      child: GenderPickerWithImage(
        unSelectedGenderTextStyle: TextStyle(
          color: Colors.grey  ,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
          selectedGenderTextStyle: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),

        onChanged: (Gender? value)
        { controller.genderValue = value!.name; },


      ),
    );
  }

  _buildDobWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller.dobController,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          hintText: 'Enter your date of birth',
          suffixIcon: IconButton(
            onPressed: () => controller.dobController.clear(),
            icon: Icon(Icons.clear),
          ),
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        onTap: () async {
          DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() {
              // date format date and then month name short form with year if edit not clear the date
              controller.dobController.text =
                  DateFormat('dd MMM yyyy').format(date);
            });
          }
        },
      ).w(350),
    );
  }
}



extension on String? {
  set value(value) {}
}

extension on TextField {
  w(int i) {
    return SizedBox(
      width: i.toDouble(),
      child: this,
    );
  }
}

class GFBorderShape {
  static const circle = GFBadgeShape.circle;
}
