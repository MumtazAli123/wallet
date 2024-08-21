// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/global/global.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/partner_controller.dart';

class PartnerView extends GetView<PartnerController> {
  const PartnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: 10,
        scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
        return  DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                // image: NetworkImage(sharedPreferences.getString('image')),
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
                color: Colors.blue),

            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 60),
                  // back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  wText('Index: $index', color: Colors.white),
                ],
              ),
            ),
        );
      }),
    );
  }
}
