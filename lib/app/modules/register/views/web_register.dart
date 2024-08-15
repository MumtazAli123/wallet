// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../home/views/bottom_page_view.dart';
import '../controllers/register_controller.dart';


class WebRegisterView extends StatefulWidget {
  const WebRegisterView({super.key});

  @override
  State<WebRegisterView> createState() => _WebRegisterViewState();
}

class _WebRegisterViewState extends State<WebRegisterView> {
  final RegisterController controller = Get.put(RegisterController());
  bool isLogin = false;
  var hintText = 'Email';
  String flagUri = '';
  final fStore = FirebaseFirestore.instance;
  final String date = DateTime.now().toString();


  // country flag
  UserModel model = UserModel();

  var totalSellerBlockNumber = 0;
  var totalSellerActiveNumber = 0;

  emailValidation() {
    if (controller.emailController.text.isEmpty) {
      wGetSnackBar(
        'Error',
        'Please enter email',
      );
    } else if (!controller.emailController.text.contains('@') ||
        !controller.emailController.text.contains('.com')) {
      wGetSnackBar(
        'Error',
        'Please enter valid email',
      );
    } else {
      controller.currentScreen.value = 1;
    }
  }

  formValidation() {
    if (controller.nameController.text.isEmpty) {
      wGetSnackBar(
        'Error',
        'Please enter name',
      );
    } else if (controller.addressController.text.isEmpty) {
      wGetSnackBar(
        'Error',
        'Please enter address',
      );
    } else if (controller.cityController.text.isEmpty) {
      wGetSnackBar(
        'Error',
        'Please enter city',
      );
    } else {
      controller.currentScreen.value = 2;
    }
  }

  phoneValidation() {
    if (controller.phoneController.text.isEmpty) {
      wGetSnackBar(
        'Error',
        'Please enter phone',
      );
    } else if (controller.phoneController.text.length < 10) {
      wGetSnackBar(
        'Error',
        'Please enter valid phone',
      );
    } else {
      controller.currentScreen.value = 3;
    }
  }

  passwordValidation() {
    if (controller.passwordController.text.isEmpty) {
      wGetSnackBar('Error', 'Please enter password');
    } else if (controller.passwordController.text.length < 6) {
      wGetSnackBar(
        'Error',
        'Please enter minimum 6 digit',
      );
    } else if (controller.confirmPasswordController.text.isEmpty) {
      wGetSnackBar('Error', 'Please enter confirm password');
    } else if (controller.passwordController.text !=
        controller.confirmPasswordController.text) {
      wGetSnackBar('Error', 'Password does not match');
    } else {
      controller.currentScreen.value = 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Obx(() {
          if (controller.currentScreen.value == 0) {
            return emailFormScreen();
          } else if (controller.currentScreen.value == 1) {
            return registerFormScreen();
          } else if (controller.currentScreen.value == 2) {
            return phoneScreen();
          } else if (controller.currentScreen.value == 3) {
            return passWordScreen();
          } else if (controller.currentScreen.value == 4) {
            return uploadFormScreen();
          } else {
            return uploadFormScreen();
          }
        }),
      ),
    );
  }

  Widget emailFormScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/login.json',
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   wText(
                    'Welcome to ZubiPay Wallet',
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   wText(
                    'Manage your money easily',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Lottie.asset('assets/lottie/enjoy.json'),
                          ),
                          SizedBox(height: 45),
                          _emailField(controller.emailController),
                          SizedBox(height: 30),
                          wButton('Next', size: 60, Colors.blue, onPressed: () {
                            emailValidation();
                          }),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget registerFormScreen() {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/login.json',
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   wText(
                    'Welcome to ZubiPay Wallet',
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   aText(
                    'Manage your money easily',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              height: double.infinity,

              padding: const EdgeInsets.all(20),
              color: Colors.blue[900],
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.0
                      ),
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/login_image.png'),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              _buildTextField(
                                  controller.nameController, 'Name', Icons.person),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildTextField(
                                  controller.addressController, 'Address', Icons.location_on),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildTextField(
                                  controller.cityController, 'City', Icons.location_city),
                              const SizedBox(
                                height: 20,
                              ),
                             Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 wButton(
                                     onPressed: () {
                                   controller.currentScreen.value = 0;
                                 },  'Previous', size: 60, Colors.grey),
                                 SizedBox(width: 20.0),
                                 wButton('Next ', size: 60,  Colors.blue, onPressed: () {
                                   formValidation();
                                 }),
                               ],
                             ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget phoneScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/login.json',
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome to ZubiPay Wallet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   aText(
                    'Manage your money easily',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('assets/images/login_image.png'),
                        ),

                        const SizedBox(height: 20.0),
                        wText("Let's get started", color: Colors.white, size: 20),
                        cText("Please enter your WhatsApp number",
                            color: Colors.white, size: 12),
                        const SizedBox(height: 20.0),
                        // wText('Enter Phone Number', color: Colors.white),
                        const SizedBox(height: 20.0),
                        Container(
                          width: 450,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _phoneField(),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          width: 450,
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              wButton(onPressed: () {
                                controller.currentScreen.value = 1;
                              },  'Previous', size: 57,  Colors.red),
                              const SizedBox(width: 20.0),
                              wButton('Next', size: 60, Colors.blue, onPressed: () {
                                phoneValidation();
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passWordScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 18.0, left: 10.0, right: 10.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //
      //       Expanded(
      //         child: Container(
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(140),
      //             ),
      //           ),
      //           height: 55,
      //           child: wButton('Back', color: Colors.red, onPressed: () {
      //             controller.currentScreen.value = 2;
      //           }),
      //         ),
      //       ),
      //       SizedBox(
      //         width: 10,
      //       ),
      //       Container(
      //         height: 57,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.only(
      //             topRight: Radius.circular(140),
      //           ),
      //         ),
      //         child: wButton('Next', color: Colors.blue[800], onPressed: () {
      //           passwordValidation();
      //         }),
      //       ),
      //     ],
      //   ),
      // ),
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/login.json',
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome to ZubiPay Wallet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  aText(
                    'Manage your money easily',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/login_image.png'),
                      ),

                      // email show here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          wText(controller.emailController.text, color: Colors.white),
                        ],
                      ),
                      SizedBox(height: 20),
                      _passwordTextField(
                          controller.passwordController, 'Password', Icons.lock),
                      SizedBox(height: 20),
                      _passwordTextField(controller.confirmPasswordController,
                          'Confirm Password', Icons.lock),
                      SizedBox(height: 20),
                      Container(
                        width: 450,
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            wButton(
                                onPressed: () {
                              controller.currentScreen.value = 2;
                            },  'Back',  Colors.red, size: 60,),
                            SizedBox(width: 20.0),
                            wButton('Next', size: 60, Colors.blue, onPressed: () {
                              passwordValidation();
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadFormScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/login.json',
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Welcome to ZubiPay Wallet',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  aText(
                    'Manage your money easily',
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        width: 450,
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Lottie.asset('assets/lottie/shop.json'),
                            ),
                            SizedBox(height: 20.0),

                            Text(
                              textAlign: TextAlign.center,
                              "Please check your information\n"
                                  "If you want to change, click back button",
                              style: GoogleFonts.kadwa(
                                color: Colors.yellowAccent[700],
                                fontSize: 12,
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            // email show here
                            ListTile(
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                title: aText("Email: ${controller.emailController.text}",
                                    color: Colors.white)),
                            ListTile(
                                leading: Icon(Icons.person, color: Colors.white),
                                title: aText("Name: ${controller.nameController.text}",
                                    color: Colors.white)),
                            ListTile(
                                leading: Icon(Icons.phone, color: Colors.white),
                                title: aText(
                                    "+${controller.countryCode}${controller.phoneController.text}",
                                    color: Colors.white)),
                            ListTile(
                                leading: Icon(Icons.location_on, color: Colors.white),
                                title: aText("Address: ${controller.cityController.text}",
                                    color: Colors.white)),
                            ListTile(
                                leading: Icon(Icons.location_city, color: Colors.white),
                                title: aText("City: ${controller.addressController.text}",
                                    color: Colors.white)),
                            SizedBox(height: 20),
                           Container(
                             width: 250,
                             height: 50,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(10),
                             ),
                             child:  wButton('Submit',  Colors.blue, size: 60, onPressed: () {
                               if (controller.formKey.currentState!.validate()) {
                                 signUp(
                                     controller.emailController.text, controller.passwordController.text);
                               }
                             }),
                           ),
                            SizedBox(height: 20),
                            GFButton(
                                text: "Back",
                                textStyle:
                                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                color: Colors.red,
                                onPressed: () {
                                  controller.currentScreen.value = 1;
                                  // Get.back();
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _emailField(TextEditingController emailController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 550,
      padding: EdgeInsets.only(right: 10),
      child: TextFormField(
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            hintText = 'Email';
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.blue),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.black),
          helperMaxLines: 1,
          border: InputBorder.none,
          suffixIcon: hintText == 'Email' &&
              controller.emailController.text.contains('.com')
              ? Container(
            margin: const EdgeInsets.only(right: 10),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(
              Icons.done,
              color: Colors.white,
              size: 20,
            ),
          )
              : null,
        ),
      ),
    );
  }

  _phoneField() {
    return TextFormField(
      controller: controller.phoneController,
      maxLength: 10,
      onChanged: (value) {
        setState(() {
          hintText = 'Phone';
        });
      },
      keyboardType: TextInputType.phone,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: 'Phone Number',
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        // like 300 1234567
        helperText: 'Enter phone no like 3001234567',
        helperStyle: const TextStyle(
          color: Colors.black,
        ),

        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    controller.selectedCountry = country;
                    controller.countryCode = country.phoneCode;
                    controller.flagUri = country.flagEmoji;
                  });
                },
              );
            },
            child: Text(
              '${controller.selectedCountry.flagEmoji} +${controller.selectedCountry.phoneCode}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ),
        suffixIcon: controller.phoneController.text.length > 9
            ? Container(
          margin: const EdgeInsets.only(right: 10),
          height: 20,
          width: 20,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: const Icon(
            Icons.done,
            color: Colors.white,
            size: 20,
          ),
        )
            : null,
      ),
    );
  }

  _passwordTextField(
      TextEditingController nameController, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 550,
      padding: EdgeInsets.all(5.0),
      child: FancyPasswordField(
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your $hint");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
          helperMaxLines: 1,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }


  _buildTextField(
      TextEditingController nameController, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 550,
      padding: EdgeInsets.only(right: 10),
      child: TextFormField(
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your $hint");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
          helperMaxLines: 1,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    QuickAlert.show(
      width: 400,
      context: context,
      type: QuickAlertType.loading,
      title: 'Please wait...',
    );
    bool isPhoneNoAvailable = await isUserPhoneAvailable(
        "+${controller.countryCode}${controller.phoneController.text}");

    try {
      if (isPhoneNoAvailable) {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          uid = value.user!.uid;
          // _uploadImageToFirebase();
          _saveUserData('');
        });
      } else {
        Get.back();
        wGetSnackBar('Error', 'Phone number already exists');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  Future<bool> isUserPhoneAvailable(String phoneNumber) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final query = await firebaseFirestore
        .collection("sellers")
        .where("phone", isEqualTo: phoneNumber)
        .get();
    return query.docs.isEmpty;
  }

  void _saveUserData(String value) async {
    // to call firestore

    try {
      User? user = fAuth.currentUser; // to call user model

      UserModel userModel = UserModel();
      userModel.uid = user!.uid;
      userModel.email = user.email;
      userModel.name = controller.nameController.text;
      userModel.phone =
      "+${controller.countryCode}${controller.phoneController.text}";
      userModel.image = value;
      userModel.sellerType = 'user';
      userModel.balance = 100.0;
      userModel.createdAt = date;
      userModel.updatedAt = date;
      //   save user data to firestore and save locally to shared preference
      await FirebaseFirestore.instance.collection('sellers').doc(uid).set({
        'uid': userModel.uid,
        'name': userModel.name,
        'email': userModel.email,
        'phone': userModel.phone,
        "city": controller.cityController.text,
        "address": controller.addressController.text,
        'image': value,
        'sellerType': userModel.sellerType,
        'status': 'approved',
        'balance': 200.0,
        'rating': 5.0,
        'createdAt': userModel.createdAt,
        'updatedAt': userModel.updatedAt,
      });
      await sharedPreferences?.setString('uid', uid!);
      await sharedPreferences?.setString(
          'name', controller.nameController.text);
      await sharedPreferences?.setString(
          'email', controller.emailController.text);
      await sharedPreferences?.setString('phone',
          '+${controller.countryCode}${controller.phoneController.text}');
      await sharedPreferences?.setString('city', controller.cityController.text);
      await sharedPreferences?.setString('address', controller.addressController.text);
      await sharedPreferences?.setString('image', value);
      await sharedPreferences?.setString('sellerType', 'user');
      await sharedPreferences?.setString('status', 'approved');
      await sharedPreferences?.setString('earning', '100.0');
      await sharedPreferences?.setString('balance', '200.0');
      await sharedPreferences?.setString('rating', '5.0');
      await sharedPreferences?.setString(
          'createdAt', DateTime.now().toString());
      await sharedPreferences?.setString(
          'sellerCart', DateTime.now().toString());

      Get.back();
      Get.offAll(() => BottomPageView());
      Get.snackbar('Success', 'User registered successfully', backgroundColor: Colors.green);
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }



}
