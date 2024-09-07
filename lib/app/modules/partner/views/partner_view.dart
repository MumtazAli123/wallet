// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../global/global.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/partner_controller.dart';

class PartnerView extends StatefulWidget {
  const PartnerView({super.key});

  @override
  State<PartnerView> createState() => _PartnerViewState();
}

class _PartnerViewState extends State<PartnerView> {
  final PartnerController controller = Get.put(PartnerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return PageView.builder(
        itemCount: 2,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/job1.png'),
                  fit: BoxFit.fill,
                ),
                color: Colors.blue),
            child: Center(
              child: Column(
                children: [
                  AppBar(
                    iconTheme: IconThemeData(color: Colors.white),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    title: aText(sharedPreferences!.getString('name')!, color: Colors.white, size: 18),
                  ),

                  // back button
                  Spacer(),
                  // partner name
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    wText("Coming Soon".tr, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 10),
                  // wr work on it
                  ElevatedButton(
                      onPressed: () {},
                      child: wText(
                        "We are working on it".tr,
                      )),

                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        });

  }
}


