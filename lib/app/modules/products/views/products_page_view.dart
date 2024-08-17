// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/models/products_model.dart';

class ProductView extends GetView<ProductsController> {
  final String? doc;
  final ProductsModel vModel;

  const ProductView({super.key, required this.doc, required this.vModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProductsPageView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ProductsPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
