import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UploadProductsView extends GetView {
  const UploadProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UploadProductsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'UploadProductsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
