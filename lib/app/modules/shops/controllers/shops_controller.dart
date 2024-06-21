import 'package:get/get.dart';

class ShopsController extends GetxController {

  var shops = [].obs;
  var isLoading = true.obs;
  var isShopsEmpty = false.obs;



  final count = 0.obs;
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
  void increment() => count.value++;
}
