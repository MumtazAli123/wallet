// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/models/seller_model.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../register/views/email_register_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends State<LoginView> {
  final controller = Get.put(LoginController());

  final auth = FirebaseAuth.instance;


  SellerModel? sellerModel = SellerModel();


  var hintText = 'Email';

  bool isLoading = false;

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      //   shadow text
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      //   shadow text
                      child: Text(
                        'Login',
                        style: GoogleFonts.paprika(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    background: Image.asset(
                      'assets/images/login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    margin: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    width: 600,
                    child: Card(
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          _emailField(),
                          SizedBox(height: 20),
                          _passwordField(),
                          SizedBox(height: 20),
                          // remember me and forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        rememberMe = value!;
                                      });
                                    },
                                  ),
                                  Text('Remember me'),
                                ],
                              ),
                              TextButton(
                                  onPressed: () {}, child: Text('Forgot password?')),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            alignment: Alignment.center,
                            width: 200,
                            height: 50,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                controller.login();
                              },
                              child: wText(
                                'Login',
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          if (GetPlatform.isIOS || GetPlatform.isAndroid)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  // Get.toNamed('/register');
                                  Get.to(() => EmailRegisterView());
                                },
                                child: Text('Register',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(18.0),
                    width: 600,
                    height: MediaQuery.of(context).size.height / 1.5,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ));
  }

  _emailField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email is required';
          }
          return emailValidator(value);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  String? emailValidator(String? email) {
    // do not show emoji keyboard
    RegExp emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegExp.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please enter a valid email';
    }
    return null;
  }

  _passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FancyPasswordField(
        controller: controller.passwordController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
      ),
    );
  }

  dTextButton({required Future? Function() onPressed, required String text}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
