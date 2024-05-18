// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/home/views/mob_home_view.dart';

import '../../../../qrcode/qrcode.dart';
import '../controllers/home_controller.dart';

class BottomPageView extends GetView {
  const BottomPageView({super.key});
  @override
  get controller => Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          pageSnapping: true,
          controller: controller.pageController,
          physics: ScrollPhysics(
            parent: NeverScrollableScrollPhysics(),
          ),
          children: [
            // HomeView(),
            HomeView(),
            Container(
              color: Colors.blue,
              child: Center(
                child: Text('Page 0'),
              ),
            ),
            QrcodePage(),
            Container(
              color: Colors.green,
              child: Center(
                child: Text('Page 2'),
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => FancyBottomNavigationPlus(
          barheight: 60,
          circleColor: Colors.blue,
          // barBackgroundColor: Colors.purple,
          tabs: [
            TabData(icon: const Icon(Icons.home), title: "Home"),
            // TabData(icon: const Icon(Icons.history), title: "History"),
            TabData(icon:  Icon(Icons.search), title: "Search"),
            TabData(icon:  Icon(Icons.qr_code), title: "QrCode"),
            TabData(icon:  Icon(Icons.wallet), title: "Wallet"),
          ],
          key: controller.bottomNavigationKey,
          initialSelection: controller.currentIndex.value,
          onTabChangedListener: (position) {
            controller.currentIndex.value = position;
            controller.pageController.jumpToPage(position);
          },
        ),
      ),
    );
  }
}
