// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/home/views/mob_home_view.dart';
import 'package:wallet/app/modules/shops/views/shops_view.dart';
import 'package:wallet/global/global.dart';
import 'package:wallet/widgets/my_drawer.dart';

import '../../../../notification/notification_page.dart';
import '../../../../qrcode/qrcode.dart';
import '../../../../search/search_screen.dart';
import '../../../../user_profile/user_profile.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/home_controller.dart';

class BottomPageView extends GetView {
  const BottomPageView({super.key});
  @override
  get controller => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationSideBar(
      //   topWidget: SafeArea(
      //     child: Container(
      //       decoration: BoxDecoration(
      //         color: Colors.blue,
      //         borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(30),
      //           bottomRight: Radius.circular(30),
      //         ),
      //       ),
      //       height: 100,
      //       child: Center(
      //         child: Text('ZubiPay'.tr, style: TextStyle(color: Colors.white, fontSize: 20)),
      //       ),
      //     ),
      //   ),
      //   extendedWidth: 300,
      //   extendedBorderRadius: BorderRadius.circular(30),
      //   items: [
      //   NavigationSideBarItem(
      //       text: 'Home', selectedIcon: Icons.home, unSelectedIcon: Icons.home_outlined),
      //   NavigationSideBarItem(text: 'Digital Wallet', selectedIcon: Icons.account_balance_wallet, unSelectedIcon: Icons.account_balance_wallet_outlined),
      //   NavigationSideBarItem(text: 'Search', selectedIcon: Icons.search, unSelectedIcon: Icons.search_outlined),
      //   NavigationSideBarItem(text: 'QrCode', selectedIcon: Icons.qr_code, unSelectedIcon: Icons.qr_code_outlined),
      // ], onItemSelected: (int value) {
      //   controller.currentIndex.value = value;
      //   controller.pageController.jumpToPage(value);
      // },
      //   isExtended: true,
      //   isIndicatorActive: false,
      //   showExtendedButton: true,
      // ),
      drawer: MyDrawer(),
      // appbar 3rd index not show
      appBar: AppBar(
        title: wText('ZubiPay'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => NotificationPage());
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              _buildLanguageBottomSheet(context);
            },
            icon: const Icon(Icons.language),
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
            HomeView(),
            // DigitalWalletView(),
            SearchScreen(),
            QrcodePage(),
            ShopsView(),
            // SliderPics(),
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
