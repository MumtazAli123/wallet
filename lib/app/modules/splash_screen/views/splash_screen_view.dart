import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../global/global.dart';
import '../../home/views/bottom_page_view.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {

  final controller = Get.put(SplashScreenController());

  startTimer() {
    fAuth.currentUser != null
        ? currentUser = fAuth.currentUser
        : currentUser = null;
    Timer(const Duration(seconds: 3), () {
      if (currentUser != null) {
        // Get.offAllNamed('/home');
        // go to bottom page view
        Get.offAll(() => const BottomPageView());
      } else {
        Get.offAllNamed('/login');
      }
    });


  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/zubipay.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            ],
          ),
        ),
      ),
    );
  }
}
