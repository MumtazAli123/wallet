import 'package:get/get.dart';

import '../controllers/shops_controller.dart';

class ShopsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopsController>(
      () => ShopsController(),
    );
  }
}
