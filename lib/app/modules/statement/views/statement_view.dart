import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/statement_controller.dart';

class StatementView extends GetView<StatementController> {
  const StatementView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatementView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StatementView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
