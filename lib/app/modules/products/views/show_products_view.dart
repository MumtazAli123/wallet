// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/app/modules/products/views/upload_products_view.dart';

import '../../../../widgets/mix_widgets.dart';

class ShowProductsView extends GetView<ProductsController> {
  const ShowProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => UploadProductsView());
        },
        label:  wText('Upload Products', color: Colors.white),
      ),
      appBar: AppBar(
        title:  wText('Products', size: 24),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ShowProductsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
