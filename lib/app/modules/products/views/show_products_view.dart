import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';

class ShowProductsView extends GetView<ProductsController> {
  const ShowProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowProductsView'),
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
