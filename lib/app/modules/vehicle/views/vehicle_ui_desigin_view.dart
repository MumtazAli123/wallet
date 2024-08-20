import 'package:flutter/material.dart';

import 'package:get/get.dart';

class VehicleUiDesiginView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VehicleUiDesiginView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VehicleUiDesiginView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
