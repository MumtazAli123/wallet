// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';

class BeautyView extends GetView <ProductsController> {
  const BeautyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'LaptopView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
