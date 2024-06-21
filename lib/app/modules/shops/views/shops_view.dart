// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../../../global/global.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/shops_controller.dart';

class ShopsView extends GetView<ShopsController> {
  const ShopsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        _buildSliderPics(),
        _buildShopsList(),
      ],
    );
  }

  _buildSliderPics() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(13.0),
        height: Get.height / 7.5,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),

          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          //   header
            wText(
              'Shops',
              color: Colors.white,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }

  _buildShopsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return _buildShopItem(index);
        },
      ),
    );
  }

  _buildShopItem(int index) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Get.theme.primaryColorDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(
            itemsList[index],
            fit: BoxFit.cover,
          ),
          Text(
            itemsList[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
