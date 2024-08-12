import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProductsUiDesignView extends GetView {
  const ProductsUiDesignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductsUiDesignView'),
        centerTitle: true,
      ),
      body: const Center(
        child:  Text(
          'ProductsUiDesignView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
