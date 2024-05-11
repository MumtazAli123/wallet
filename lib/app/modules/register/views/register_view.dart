// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/home/views/home_view.dart';

import '../../../../global/global.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final controller = Get.put(RegisterController());

  final fStore = FirebaseFirestore.instance;

  // country flag

  bool _isImageLoaded = false;
  bool _isPasswordVisible = false;
  bool isLoading = false;

  fromValidation() {
    if (controller.emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email');
    } else if (!controller.emailController.text.contains('@')) {
      Get.snackbar('Error', 'Please enter valid email');
    } else if (controller.passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter password');
    } else if (controller.confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter confirm password');
    } else if (controller.phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
    } else if (controller.phoneController.text.length < 10) {
      Get.snackbar('Error', 'Phone number must be 10 digits');
    } else if (controller.image == null) {
      Get.snackbar('Error', 'Please select image');
    } else if (controller.passwordController.text !=
        controller.confirmPasswordController.text) {
      Get.snackbar('Error', 'Password does not match');
    } else {
      _registerUser();
    }
  }

  void clearText() {
    controller.nameController.clear();
    controller.emailController.clear();
    controller.phoneController.clear();
    controller.passwordController.clear();
    controller.confirmPasswordController.clear();
  }

  @override
  void initState() {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    controller.imagePicker = ImagePicker();
    super.initState();
    controller.nameFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: wText('Register', color: Colors.white, size: 20),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImage(context),
              _buildForm(context),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  _buildImage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey[300],
            child: _isImageLoaded
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.file(
                      controller.image!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(70),
                      ),
                    ),
                    width: 140,
                    height: 140,
                    child: Image.asset(
                      'assets/images/bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  _showPicker(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: controller.nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            _phoneField(),
            SizedBox(height: 20.0),
            FancyPasswordField(
              controller: controller.passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            FancyPasswordField(
              controller: controller.confirmPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fromValidation();
              },
              child: const Text('Register'),
            ),
          ],
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
          controller.phoneController.text = value;
        });
      },
      keyboardType: TextInputType.phone,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        hintText: 'Phone Number',
        // like 300 1234567
        helperText: 'Enter phone number like 300 1234567',
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

  void _showPicker(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Select Image',
      text: 'Select image from gallery or camera',
      widget: Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _imgFromCamera();
                  Get.back();
                },
                label: const Text('Camera'),
                icon: const Icon(Icons.camera),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  _imgFromGallery();
                  Get.back();
                },
                label: const Text('Gallery'),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
        ],
      ),
      confirmBtnText: 'Cancel',
    );
  }

  void _imgFromGallery() {
    controller.imagePicker!
        .pickImage(source: ImageSource.gallery)
        .then((value) {
      setState(() {
        controller.image = File(value!.path);
        _isImageLoaded = true;
      });
    });
  }

  void _imgFromCamera() {
    controller.imagePicker!.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        controller.image = File(value!.path);
        _isImageLoaded = true;
      });
    });
  }

  // already have an account text widget
  _buildLoginButton() {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already have an account?'),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Now Login',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _registerUser() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Please wait...',
    );
    try {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: controller.emailController.text,
              password: controller.passwordController.text)
          .then((value) {
        uid = value.user!.uid;
        _uploadImageToFirebase();
      });
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  void _uploadImageToFirebase() {
    try {
      FirebaseStorage.instance
          .ref('sellerImage/$uid')
          .putFile(controller.image!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          _saveUserData(value);
        });
      });
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  void _saveUserData(String value) async {
    try {
      //   svae user data to firestore and save locally to shared preference
      await FirebaseFirestore.instance.collection('sellers').doc(uid).set({
        'uid': uid,
        'name': controller.nameController.text,
        'email': controller.emailController.text,
        'phone': "+${controller.countryCode}${controller.phoneController.text}",
        'image': value,
        'sellerType': 'user',
        'status': 'approved',
        "earning": 0.0,
        "balance": 0.0,
        'createdAt': DateTime.now(),
        "updatedAt": DateTime.now(),
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
      await sharedPreferences?.setString('earning', '0.0');
      await sharedPreferences?.setString('balance', '0.0');
      await sharedPreferences?.setString(
          'createdAt', DateTime.now().toString());
      await sharedPreferences?.setString(
          'sellerCart', DateTime.now().toString());

      Get.back();
      Get.offAll(() =>  HomeView(

      ));
      Get.snackbar('Success', 'User registered successfully');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }
}
