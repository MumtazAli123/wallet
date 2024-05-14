import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WebHomeView extends GetView {
  const WebHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WebHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
