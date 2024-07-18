import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProductsUiDesiginView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProductsUiDesiginView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ProductsUiDesiginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
