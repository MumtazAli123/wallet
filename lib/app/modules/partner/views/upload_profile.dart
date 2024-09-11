// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
  List<String> professionList = ["Doctor", "Engineer", "Businessman", "Employment", "Designer", "Teacher", "Pilot", "Policeman", "Soldier", "Civil Servant", "Musician", "Actor", "Artist", "Writer", "Journalist", "Photographer", "Technician", "Other"];
  List<String> drinkList = ["Yes", "No", "Occasionally"];
  String? professionValue;
  String? drinkValue;

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
    }
    if (controller.dobController.text.isEmpty) {
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

  void validateBioFormScreen() {
    if (controller.bioController.text.isEmpty) {
      wGetSnackBar("Bio", "Please enter your bio", color: Colors.red);
      return;
    } else {
      controller.currentScreen.value = 3;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.pickedFile = Rx<File?>(null);
    currentAgeToDob();
    if (controller.genderValue == null) {
      isGender = true;
    } else {
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
            return bioDetailsFormScreen();
          } else if (controller.currentScreen.value == 3) {
            return profileScreen();
          } else {
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
            title: 'Bio Details',
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => controller.currentScreen.value = 0,
            ),
          ),
          //  add income yearly
          Padding(
              padding: EdgeInsets.all(10),
              child: wTextField(
                controller: controller.incomeController,
                keyboardType: "number",
                labelText: 'Income',
                hintText: 'Enter your income yearly',
                prefixIcon: Icons.monetization_on,
              )),
          // bio
          Padding(
              padding: EdgeInsets.all(10),
              child: wTextField(
                controller: controller.bioController,
                keyboardType: "text",
                labelText: 'Bio',
                hintText: 'Enter your bio',
                prefixIcon: Icons.info,
              )),
          // languages
          Padding(
              padding: EdgeInsets.all(10),
              child: wTextField(
                controller: controller.languagesController,
                keyboardType: "text",
                labelText: 'Languages',
                hintText: 'Enter your languages',
                prefixIcon: Icons.language,
              )),
          // education
          Padding(
              padding: EdgeInsets.all(10),
              child: wTextField(
                controller: controller.educationController,
                keyboardType: "text",
                labelText: 'Education',
                hintText: 'Enter your education',
                prefixIcon: Icons.school,
              )),
          // religion
          Padding(
              padding: EdgeInsets.all(10),
              child: wTextField(
                controller: controller.religionController,
                keyboardType: "text",
                labelText: 'Religion',
                hintText: 'Enter your religion',
                prefixIcon: Icons.add_to_home_screen,
              )),
          // profession
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Profession',
                hintText: 'Select your profession',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: professionValue,
              onChanged: (newValue) {
                setState(() {
                  professionValue = newValue.toString();
                });
              },
              items: professionList.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          // nationalityController
          Padding(
              padding: EdgeInsets.all(10),
              child: wTextField(
                controller: controller.nationalityController,
                keyboardType: "text",
                labelText: 'Nationality',
                hintText: 'Enter your Nationality',
                prefixIcon: Icons.flag,
              )),
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

  _genderWidget() {
    return Center(
      child: GenderPickerWithImage(
        unSelectedGenderTextStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        selectedGenderTextStyle: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        onChanged: (Gender? value) {
          controller.genderValue = value!.name;
        },
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

  Widget bioDetailsFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lifestyle'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => controller.currentScreen.value = 1,
        ),
      ),
      body: ListView(
        children: [
          // single or married
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Marital Status',
                hintText: 'Select your marital status',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.marital,
              onChanged: (newValue) {
                setState(() {
                  controller.marital = newValue.toString();
                });
              },
              items: [
                'Single',
                'Married',
                "Engage",
                "Divorced",
                "Widow",
                "Widower",
                "Other"
              ].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          // living
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Living',
                hintText: 'Select your living status',
                prefixIcon: Icon(EvaIcons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.live,
              onChanged: (newValue) {
                setState(() {
                  controller.live = newValue.toString();
                });
              },
              items: ['Alone', 'With Family', 'With Friends', 'With Partner', 'With Kids', 'Other']
                  .map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),

          // smoking
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Smoking',
                hintText: 'Do you smoke?',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.smoke,
              onChanged: (newValue) {
                setState(() {
                  controller.smoke = newValue.toString();
                });
              },
              items: ['Yes', 'No', 'Occasionally'].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          // drinking
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Drinking',
                hintText: 'Do you drink?',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.drink,
              onChanged: (newValue) {
                setState(() {
                  controller.drink = newValue.toString();
                });
              },
              items: ['Yes', 'No', 'Occasionally'].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          // body type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Body Type',
                hintText: 'Select your body type',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.body,
              onChanged: (newValue) {
                setState(() {
                  controller.body = newValue.toString();
                });
              },
              items: ['Slim', 'Average', 'Athletic', 'Heavy', "Normal"].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Kids',
                hintText: 'Do you have kids?',
                prefixIcon: Icon(Icons.child_friendly),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.kid,
              onChanged: (newValue) {
                setState(() {
                  controller.kid = newValue.toString();
                });
              },
              items: ['Yes', 'No'].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          // want kids
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Want Kids',
                hintText: 'Do you want kids?',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.wantKid,
              onChanged: (newValue) {
                setState(() {
                  controller.wantKid = newValue.toString();
                });
              },
              items: ['Yes', 'No', 'After Decision', 'Latter Wants'].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          // looking for
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Looking For',
                hintText: 'Select what you are looking for',
                prefixIcon: Icon(EvaIcons.heart),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              value: controller.lookingFor,
              onChanged: (newValue) {
                setState(() {
                  controller.lookingFor = newValue.toString();
                });
              },
              items: ['Friendship', 'Relationship', 'Marriage', 'Other'].map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.0),
          wCustomButton(
              color: Colors.green,
              width: 250,
              text: 'Next',
              icon: Icons.arrow_forward,
              onPressed: () {
                validateBioFormScreen();
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
          // name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              children: [
                //   name
                TableRow(
                  children: [
                    aText('Name', color: Colors.blue),
                    aText(sharedPreferences!.getString('name') ?? '',
                        color: Colors.green),
                  ],
                ),
                //   email
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Email', color: Colors.blue),
                    aText(sharedPreferences!.getString('email') ?? '',
                        color: Colors.green),
                  ],
                ),
                //   phone
                TableRow(
                  children: [
                    aText('Phone', color: Colors.blue),
                    aText(sharedPreferences!.getString('phone') ?? '',
                        color: Colors.green),
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
                    aText(controller.incomeController.text,
                        color: Colors.green),
                  ],
                ),
                // bio
                TableRow(
                  children: [
                    aText('Bio', color: Colors.blue),
                    aText(controller.bioController.text, color: Colors.green),
                  ],
                ),
                // languages
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Languages', color: Colors.blue),
                    aText(controller.languagesController.text,
                        color: Colors.green),
                  ],
                ),
                // education
                TableRow(
                  children: [
                    aText('Education', color: Colors.blue),
                    aText(controller.educationController.text,
                        color: Colors.green),
                  ],
                ),
                // religion
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Religion', color: Colors.blue),
                    aText(controller.religionController.text,
                        color: Colors.green),
                  ],
                ),
                // profession
                TableRow(
                  children: [
                    aText('Profession', color: Colors.blue),
                    aText(professionValue ?? '', color: Colors.green),
                  ],
                ),
              // nationality
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Nationality', color: Colors.blue),
                    aText(controller.nationalityController.text,
                        color: Colors.green),
                  ],
                ),
              //   single or marred
                TableRow(
                  children: [
                    aText('Marital Status', color: Colors.blue),
                    aText( controller.marital?? '', color: Colors.green),
                  ],
                ),
              //   living
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Living', color: Colors.blue),
                    aText(controller.live ?? '', color: Colors.green),
                  ],
                ),
              //   smoking
                TableRow(
                  children: [
                    aText('Smoking', color: Colors.blue),
                    aText(controller.smoke ?? '', color: Colors.green),
                  ],
                ),
              //   drinking
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Drinking', color: Colors.blue),
                    aText(controller.drink ?? '', color: Colors.green),
                  ],
                ),
              //   body type
                TableRow(
                  children: [
                    aText('Body Type', color: Colors.blue),
                    aText(controller.body ?? '', color: Colors.green),
                  ],
                ),
              //   kids
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Kids', color: Colors.blue),
                    aText(controller.kid ?? '', color: Colors.green),
                  ],
                ),
              //   want kids
                TableRow(
                  children: [
                    aText('Want Kids', color: Colors.blue),
                    aText(controller.wantKid ?? '', color: Colors.green),
                  ],
                ),
              //   looking for
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  children: [
                    aText('Looking For', color: Colors.blue),
                    aText(controller.lookingFor ?? '', color: Colors.green),
                  ],
                ),



              ],
            ),
          ),

          SizedBox(height: 10.0),
          //   button
          wCustomButton(
              color: Colors.green,
              width: 250,
              text: 'Save Profile',
              icon: Icons.save,
              onPressed: () {
                setState(() {
                  controller.saveProfile();
                });
              }),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
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
