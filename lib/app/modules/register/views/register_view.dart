// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/home/views/bottom_page_view.dart';
import 'package:wallet/app/modules/home/views/mob_home_view.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final controller = Get.put(RegisterController());

  final fStore = FirebaseFirestore.instance;
  final String date = DateTime.now().toString();

  // country flag
  UserModel model = UserModel();
  bool _isImageLoaded = false;
  bool isLoading = false;
  var hintText = 'Email';

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
      signUp(
          controller.emailController.text, controller.passwordController.text);
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
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildImage(context),
                _buildForm(context),
              ],
            ),
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
                : ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                      'assets/images/bg.png',
                      width: 140,
                      height: 140,
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
      child: Center(
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _nameField(),
              SizedBox(height: 20.0),
              _emailField(),
              SizedBox(height: 20.0),
              _phoneField(),
              SizedBox(height: 20.0),
              _passwordField(),
              SizedBox(height: 10.0),
              _confirmPasswordField(),
              SizedBox(height: 30.0),
              _registerButton(),
              SizedBox(height: 10.0),
              _loginLink(),
            ],
          ),
        ),
      ),
    );
  }

  _nameField() {
    return TextFormField(
      controller: controller.nameController,
      maxLength: 20,
      focusNode: controller.nameFocus,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        controller.upperCaseTextFormatter,
      ],
      decoration: InputDecoration(
        helperText: 'Enter your name as per CNIC',
        labelText: 'Name',
        hintText: 'Enter your name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        // when enter some value in name field then change hintText to Name
        if (value!.isEmpty) {
          return 'Name is required';
        } else if (value.length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
      onFieldSubmitted: (value) {
        controller.nameFocus.unfocus();
        FocusScope.of(context).requestFocus(controller.nameFocus);
      },
    );
  }

  _emailField() {
    return TextFormField(
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        setState(() {
          hintText = 'Email';
        });
      },
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is required';
        }
        return null;
      },
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

  _passwordField() {
    return FancyPasswordField(
      controller: controller.passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
    );
  }

  _confirmPasswordField() {
    return FancyPasswordField(
      controller: controller.confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Confirm Password is required';
        }
        return null;
      },
    );
  }

  _registerButton() {
    return ElevatedButton(
      onPressed: () {
        if (controller.formKey.currentState!.validate()) {
          fromValidation();
        }
      },
      child: const Text('Register'),
    );
  }

  _loginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?'),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    QuickAlert.show(
      width: 400,
      context: context,
      type: QuickAlertType.info,
      title: 'Select Image',
      text: 'Select image from gallery or camera',
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _imgFromCamera();
                  Get.back();
                },
                child: const Text('Camera'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  _imgFromGallery();
                  Get.back();
                },
                child: const Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
      confirmBtnText: 'Cancel',
    );
    // AwesomeDialog(
    //   width: 400,
    //   showCloseIcon: true,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   context: context,
    //   dialogType: DialogType.info,
    //   dialogBackgroundColor: Colors.blue[100],
    //   animType: AnimType.leftSlide,
    //   btnCancelOnPress: () {
    //   },
    //   btnCancelText: 'Cancel',
    //   body: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       ElevatedButton(
    //         onPressed: () {
    //           _imgFromCamera();
    //           Get.back();
    //         },
    //         child: const Text('Camera'),
    //       ),
    //       const SizedBox(width: 5),
    //       ElevatedButton(
    //         onPressed: () {
    //           _imgFromGallery();
    //           Get.back();
    //         },
    //         child: const Text('Gallery'),
    //       ),
    //     ],
    //   ),
    // ).show();
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
          _uploadImageToFirebase();
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

  void _uploadImageToFirebase() {
    try {
      FirebaseStorage.instance
          .ref('sellerImage/$uid')
          .putFile(controller.image!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          _saveUserData(value);
          // postDetailsToFireStore( value);
        });
      });
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    }
  }

  postDetailsToFireStore(String value) {
    FirebaseFirestore firebaseFirestore =
        FirebaseFirestore.instance; // to call firestore
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

    firebaseFirestore.collection("sellers").doc(user.uid).set({
      'uid': userModel.uid,
      'name': userModel.name,
      'email': userModel.email,
      'phone': userModel.phone,
      'image': value,
      'sellerType': userModel.sellerType,
      'status': 'approved',
      'balance': 100.0,
      'createdAt': userModel.createdAt,
      'updatedAt': userModel.updatedAt,
    }).then((value) async {
      await sharedPreferences?.setString('uid', uid!);
      await sharedPreferences?.setString(
          'name', controller.nameController.text);
      await sharedPreferences?.setString(
          'email', controller.emailController.text);
      await sharedPreferences?.setString('phone',
          '+${controller.countryCode}${controller.phoneController.text}');
      await sharedPreferences?.setString('image', controller.image!.path);
      await sharedPreferences?.setString('sellerType', 'user');
      await sharedPreferences?.setString('status', 'approved');
      await sharedPreferences?.setString('balance', '100.0');
      await sharedPreferences?.setString(
          'createdAt', DateTime.now().toString());
      await sharedPreferences?.setString(
          'sellerCart', DateTime.now().toString());

      Get.back();
      Get.offAll(() => HomeView());
      Get.snackbar('Success', 'User registered successfully');
    }).catchError((e) {
      Get.back();
      Get.snackbar('Error', e.toString());
    });
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
        'image': value,
        'sellerType': userModel.sellerType,
        'status': 'approved',
        'balance': 100.0,
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
      await sharedPreferences?.setString('balance', '100.0');
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
