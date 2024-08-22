// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/models/seller_model.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/responsive.dart';
import '../../register/views/mob_register_view.dart';
import '../controllers/login_controller.dart';
import 'forgot_view.dart';

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
        backgroundColor: Colors.black,
        body: ResponsiveWidget(
          mobiView: _buildMobBody(),
          webView: _buildWebBody(),
        ),
      ),
    );
  }

  _buildMobBody() {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset('assets/lottie/animation.json'),
              ),
              SizedBox(height: 10.0),

              aText('Welcome to ZubiPay'.tr, size: 14, color: Colors.white),
              // aText('Login'.tr, size: 54, color: Colors.white),
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
                        focusColor: Colors.black,
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      aText('Remember me'.tr, color: Colors.white, size: 14),
                    ],
                  ),
                  Expanded(child: TextButton(
                      onPressed: () {
                        Get.to(() => ForgotView());
                      },
                      child: aText('Forgot password?', color: Colors.yellowAccent, size: 14)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  controller.login();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 50,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: wText(
                    'Login',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    aText('Don\'t have an account?', color: Colors.white, size: 12),
                    TextButton(
                      onPressed: () {
                        // Get.toNamed('/register');
                        Get.to(() => MobRegisterView());
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                      },
                      child: aText('Register now', color: Colors.yellowAccent),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  _buildWebBody() {
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
          width: 1100,
          height: 700,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(18.0),
                  width: 400,
                  height: 600,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      aText('Welcome Here', size: 14, color: Colors.black),
                      aText('Login', size: 54, color: Colors.black),
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
                                focusColor: Colors.black,
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              aText('Remember me', color: Colors.black),
                            ],
                          ),
                          TextButton(
                              onPressed: () {},
                              child: aText('Forgot password?', color: Colors.pinkAccent)),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            aText('Don\'t have an account?', color: Colors.black),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/register');
                                // Get.to(() => EmailRegisterView());
                              },
                              child: aText('Register', color: Colors.blue),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )),
              Expanded(child: Center(child: Image.asset('assets/images/login_1.png', height: 500, width: 500, fit: BoxFit.cover))),

            ],
          ),

        ),
      ),
    );
  }

  _emailField() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              hintText = 'Email';
            });
          },
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: Colors.black),
            // labelText: 'Email',
            hintText: 'Enter your email',
            border: InputBorder.none,
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

          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
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
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child: FancyPasswordField(
          style: TextStyle(color: Colors.black),
          controller: controller.passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.lock, color: Colors.black),
            labelStyle: TextStyle(color: Colors.black),
            // border: InputBorder.none,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
        ),
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
