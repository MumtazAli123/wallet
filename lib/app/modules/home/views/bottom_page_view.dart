// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/home/views/mob_home_view.dart';
import 'package:wallet/app/modules/shops/views/shops_view.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../qrcode/qrcode.dart';
import '../../../../search/search_screen.dart';
import '../../../../user_profile/user_profile.dart';
import '../controllers/home_controller.dart';

class BottomPageView extends GetView {
  const BottomPageView({super.key});
  @override
  get controller => Get.put(HomeController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: SizedBox.expand(
        child: PageView(
          pageSnapping: true,
          controller: controller.pageController,
          physics: ScrollPhysics(
            parent: NeverScrollableScrollPhysics(),
          ),
          children: [
            HomeView(),
            // DigitalWalletView(),
            SearchScreen(),
            QrcodePage(),
            ShopsView(),
            // SliderPics(),
            // Container(
            //   color: Colors.red,
            // ),
            ProfileScreen(),


          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => FancyBottomNavigationPlus(
          barheight: 90,
          circleColor: Colors.blue,
          // barBackgroundColor: Colors.purple,
          tabs: [
            TabData(icon: const Icon(Icons.wallet), title: "Wallet".tr),
            // TabData(icon: const Icon(Icons.history), title: "History"),
            TabData(icon:  Icon(Icons.search,), title: "Search".tr),
            TabData(icon:  Icon(Icons.qr_code), title: "QrCode".tr),
            TabData(icon:  Icon(Icons.shop), title: "Shops".tr),
            TabData(icon:  Icon(Icons.person), title: "Profile".tr),
          //   TabData(
          // //     user image
          //     icon: sharedPreferences!.getString('image')!.isEmpty
          //         ? const Icon(Icons.person)
          //         : CircleAvatar(
          //             backgroundImage: NetworkImage(
          //                 sharedPreferences!.getString('image')!
          //             ),
          //           ),
          //     title: "Profile".tr),

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
