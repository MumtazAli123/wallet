// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wallet/app/modules/home/views/bottom_page_view.dart';
import 'package:wallet/app/modules/home/views/mob_home_view.dart';

import '../../../../global/global.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/responsive.dart';
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
    } else if (controller.imageMob == null) {
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

  uploadFormScreen() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ResponsiveWidget(
          mobiView: _buildMobBody(context),
          webView: _buildWebBody(context),
        ),
      ),
    );
  }

  otpDefaultScreen() {
    return Scaffold(
      body: Center(
          child: Column(
        //   otp screen design
        children: [
          const SizedBox(height: 100),
          const Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Please enter the OTP sent to your on email ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Enter OTP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Resend OTP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Submit'),
          ),
        ],
      )),
    );
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
    // return isLoading ? otpDefaultScreen() : uploadFormScreen();
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : uploadFormScreen();
  }

  _buildMobBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.purple[900]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(18.0),
          width: 400,
          height: 800,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildMobImage(context),
                _buildForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildMobImage(BuildContext context) {
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
                      controller.imageMob!,
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
      style: TextStyle(
        color: Colors.black,
      ),
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
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText: 'Enter your name',
        helperStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixIcon: Icon(Icons.person, color: Colors.black),
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
      style: const TextStyle(
        color: Colors.black,
      ),
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
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText: 'Enter your email',
        helperStyle: const TextStyle(
          color: Colors.black,
        ),
        prefixIcon: Icon(Icons.email, color: Colors.black),
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
      style: const TextStyle(
        color: Colors.black,
      ),
      controller: controller.passwordController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        labelText: 'Password',
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
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
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.black),
        labelText: 'Confirm Password',
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
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
    // return ElevatedButton(
    //     onPressed: () {
    //       if (controller.formKey.currentState!.validate()) {
    //         fromValidation();
    //       }
    //     },
    //     child: wText('Register', color: Colors.white, size: 18.0),
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Colors.green,
    //       padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20),
    //       ),
    //     ));
    return Container(
      alignment: Alignment.center,
      width: 300,
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.purple[900]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          // if (controller.formKey.currentState!.validate()) {
          //   fromValidation();
          // }
          if (controller.formKey.currentState!.validate()) {
            fromValidation();
          }
        },
        child: wText(
          'Register',
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  _loginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        aText('Already have an account?', color: Colors.black),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: aText('Login', color: Colors.green),
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
  }

  void _imgFromGallery() async {
    controller.imagePicker!
        .pickImage(source: ImageSource.gallery)
        .then((value) {
      setState(() {
        controller.imageMob = File(value!.path);
        _isImageLoaded = true;
      });
    });

  }

  void _imgFromCamera() {
    controller.imagePicker!.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        controller.imageMob = File(value!.path);
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
          .putFile(controller.imageMob!)
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
      'rating': 0.0,
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
      await sharedPreferences?.setString('image', controller.imageMob!.path);
      await sharedPreferences?.setString('sellerType', 'user');
      await sharedPreferences?.setString('status', 'approved');
      await sharedPreferences?.setString('balance', '100.0');
      await sharedPreferences?.setString('rating', '0.0');
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

  _buildWebBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.purple[900]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(18.0),
          width: 1200,
          height: 800,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildWebImage(context),
                      _buildForm(context),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                children: [
                  Center(
                      child: Image.asset('assets/images/login_1.png',
                          height: 500, width: 500, fit: BoxFit.cover)),
                  Expanded(
                    child: Container(
                      width: 200,
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  _buildWebImage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(70),
            ),
            child: _isImageLoaded
                ? Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      image: DecorationImage(
                        image: MemoryImage(controller.selectedWebImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/bg.png'),
                        fit: BoxFit.cover,
                      ),
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
                  _selectImage(context);
                },
              ),
            ),
          ),
        ],
      )
    );
  }

  void _selectImage(BuildContext context) {
    // if (kIsWeb) {
    //   final ImagePicker _picker = ImagePicker();
    //   _picker.pickImage(source: ImageSource.gallery).then((value) {
    //     if (value != null) {
    //       var selected = File(value.path);
    //       setState(() {
    //         controller.selectedWebImage = selected.readAsBytesSync();
    //         _pickedImage = File('a');
    //         _isImageLoaded = true;
    //       });
    //     } else {
    //       Get.snackbar('Error', 'No image selected');
    //     }
    //   });
    // }
    if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      _picker.pickImage(source: ImageSource.gallery).then((value) {
        if (value != null) {
          var selected = File(value.path);
          setState(() {
            controller.selectedWebImage = selected.readAsBytesSync();
            _isImageLoaded = true;
          });
        } else {
          Get.snackbar('Error', 'No image selected');
        }
      });
    }
  }


}