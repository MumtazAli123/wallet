// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../home/views/bottom_page_view.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController controller = Get.find<RegisterController>();

  bool isLogin = false;
  var hintText = 'Email';
  String flagUri = '';

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
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    controller.nameFocus.requestFocus();
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
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: wText('Enter Email', color: Colors.white),
      ),
      body: Center(
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
                    wButton('Next', Colors.blue, onPressed: () {
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
    );
  }

  Widget registerFormScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(140),
                ),
              ),
              height: 60,
              child: wButton('Back', Colors.red, onPressed: () {
                controller.currentScreen.value = 0;
              }),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(140),
                ),
              ),
              child: wButton('Next',  Colors.blue, onPressed: () {
                formValidation();
              }),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: wText('Enter Name and Address', size: 16, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset('assets/lottie/login.json'),
                  ),
                  SizedBox(height: 20),
                  wTextField(
                    controller: controller.nameController,
                    hintText: "Enter Name",
                    labelText: "Name",
                    keyboardType: "text",
                    prefixIcon: Icons.person,
                  ),

                  // _buildTextField(
                  //     controller.nameController, 'Name', Icons.person),
                  SizedBox(height: 20),
                  _buildTextField(controller.addressController, 'Address',
                      Icons.location_on),
                  SizedBox(height: 20),
                  _buildTextField(
                      controller.cityController, 'City', Icons.location_city),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget phoneScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(140),
                  ),
                ),
                height: 55,
                child: wButton('Back', Colors.red, onPressed: () {
                  controller.currentScreen.value = 1;
                }),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(140),
                ),
              ),
              child: wButton('Next',  Colors.blue[800]!, onPressed: () {
                phoneValidation();
              }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: wText('Enter Phone Number', color: Colors.white),
      ),
      body: SafeArea(
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
                    padding: const EdgeInsets.all(20),
                    width: 350,
                    height: 140,
                    child: Image.asset(
                      'assets/images/login.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  wText("Let's get started", color: Colors.white, size: 20),
                  cText("Please enter your WhatsApp number",
                      color: Colors.white),
                  const SizedBox(height: 20.0),
                  // wText('Enter Phone Number', color: Colors.white),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _phoneField(),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passWordScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, left: 10.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(140),
                  ),
                ),
                height: 55,
                child: wButton('Back', Colors.red, onPressed: () {
                  controller.currentScreen.value = 2;
                }),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(140),
                ),
              ),
              child: wButton('Next',  Colors.blue[800]!, onPressed: () {
                passwordValidation();
              }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: wText('Enter Password', color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset('assets/lottie/coins.json'),
                ),
                SizedBox(height: 20.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadFormScreen() {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: wText('Submit Form', color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset('assets/lottie/shop.json'),
                  ),
                  SizedBox(height: 20.0),

                  aText(
                    "Please check your information\n"
                    "If you want to change, click back button",
                    size: 14,
                    color: Colors.yellowAccent,
                  ),
                  Divider(),
                  // email show here
                  ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      title: wText("Email: ${controller.emailController.text}",
                          color: Colors.white)),
                  ListTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: wText("Name: ${controller.nameController.text}",
                          color: Colors.white)),
                  ListTile(
                      leading: Icon(Icons.phone, color: Colors.white),
                      title: wText(
                          "+${controller.countryCode}${controller.phoneController.text}",
                          color: Colors.white)),
                  ListTile(
                      leading: Icon(Icons.location_on, color: Colors.white),
                      title: wText("Address: ${controller.cityController.text}",
                          color: Colors.white)),
                  ListTile(
                      leading: Icon(Icons.location_city, color: Colors.white),
                      title: wText("City: ${controller.addressController.text}",
                          color: Colors.white)),
                  SizedBox(height: 20),
                  wButton('Submit',Colors.blue, onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      signUp(controller.emailController.text,
                          controller.passwordController.text);
                    }
                  }),
                  SizedBox(height: 20),
                  // wButton('Back', color: Colors.red, onPressed: () {
                  //   controller.currentScreen.value = 1;
                  //   // Get.back();
                  // }),
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
        inputFormatters: [
          RegisterController.textUpperCaseTextFormatter(),
        ],
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

  _passwordTextField(
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
        Get.snackbar('Error', 'Phone number already exists');
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
      userModel.sellerType = 'user';
      userModel.balance = 100.0;
      userModel.createdAt = DateTime.now().toString();
      userModel.updatedAt = DateTime.now().toString();
      //   save user data to firestore and save locally to shared preference
      await FirebaseFirestore.instance.collection('sellers').doc(uid).set({
        'uid': userModel.uid,
        'name': userModel.name,
        'email': userModel.email,
        'phone': userModel.phone,
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
      Get.snackbar('Success', 'User registered successfully');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }
}
