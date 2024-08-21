import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/inspection_controller.dart';

class InspectionView extends GetView<InspectionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('InspectionView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'InspectionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
