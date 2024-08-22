// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/partner_controller.dart';

class PartnerView extends GetView<PartnerController> {
  const PartnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: 5,
        scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
        return  DecoratedBox(
            decoration: BoxDecoration(
              image: controller.image != ''
                  ? DecorationImage(
                      image: NetworkImage(controller.image),
                      fit: BoxFit.cover,
                    )
                  : null,
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
                  Spacer(),
                  // partner name
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: wText("Coming Soon".tr, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 10),
                  // wr work on it
                  ElevatedButton(onPressed: (){}, child: wText("We are working on it".tr,)),

                  SizedBox(height: 30),

                ],
              ),
            ),
        );
      }),
      // body: _buildBody(),

    );
  }

}
