import 'dart:io';

import 'package:get/get.dart';

class ProductsController extends GetxController {

  bool uploading = false, next = false;
  final List<File> _images = [];
  List<String> urlList = [];
  double val = 0;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

}
