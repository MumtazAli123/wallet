import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TimeStaementView extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TimeStaementView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'TimeStaementView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
