// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet/app/modules/login/controllers/login_controller.dart';

import '../../../../widgets/mix_widgets.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  final controller = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/login.json',
                      width: 400,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Welcome to ZubiPay Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Manage your money easily',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       wText(
                        'Login',
                        size: 30,
                         color: Colors.black,

                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: controller.emailController,
                        decoration:  InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FancyPasswordField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:  InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                          ),
                        ),
                      ),
                       SizedBox(
                        height: 20,
                      ),
                      wButton(
                        'Login',
                          Colors.blue,
                        size: 50,

                        onPressed: () {
                          controller.login();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           aText('Don\'t have an account?', color: Colors.black),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/register');
                            },
                            child:  wText('Register Now', color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
