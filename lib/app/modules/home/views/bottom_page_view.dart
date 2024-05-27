// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/home/views/mob_home_view.dart';
import 'package:wallet/app/modules/statement/views/wallet_view.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../models/user_model.dart';
import '../../../../notification/notification_page.dart';
import '../../../../qrcode/qrcode.dart';
import '../../../../search/search_screen.dart';
import '../../../../user_profile/user_profile.dart';
import '../../../../widgets/mix_widgets.dart';
import '../../../../widgets/slider_pics.dart';
import '../controllers/home_controller.dart';

class BottomPageView extends GetView {
  const BottomPageView({super.key});
  @override
  get controller => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: wText('ZubiPay'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => NotificationPage());
            },
            icon: Icon(Icons.notifications),
          ),
        //   language
          IconButton(
            onPressed: () {
              _buildLanguageBottomSheet(context);
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
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
            // SearchScreen(),
            DigitalWalletView(
              model: UserModel(
                name: sharedPreferences!.getString('name') ?? '',
                email: sharedPreferences!.getString('email') ?? '',
                image: sharedPreferences!.getString('image') ?? '',
                phone: sharedPreferences!.getString('phone') ?? '',
                uid: sharedPreferences!.getString('uid') ?? '',
              ),
            ),
            QrcodePage(),
            SliderPics(),
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
            TabData(icon: const Icon(Icons.home), title: "Home".tr),
            // TabData(icon: const Icon(Icons.history), title: "History"),
            TabData(icon:  Icon(Icons.search,), title: "Search".tr),
            TabData(icon:  Icon(Icons.qr_code), title: "QrCode".tr),
            TabData(icon:  Icon(Icons.wallet), title: "Wallet".tr),
            TabData(
          //     user image
              icon: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                    sharedPreferences!.getString('image') ?? 'https://pay-saw.com/storage/app/public/'),
                  ),

              title: "Profile".tr,
            ),
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

  void _buildLanguageBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.5,
        width: 600,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Language'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    var locale = const Locale('en', 'US');
                    Get.updateLocale(locale);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wText('English'.tr, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // arabic
                    var locale = const Locale('sd', 'PK');
                    Get.updateLocale(locale);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wText('Sindhi'.tr, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // hindi
                    var locale = const Locale('hi', 'IN');
                    Get.updateLocale(locale);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wText('Hindi'.tr, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // arabic
                    var locale = const Locale('ar', 'SA');
                    Get.updateLocale(locale);
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wText('Arabic'.tr, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
