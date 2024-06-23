import 'package:get/get.dart';

import '../controllers/realstate_controller.dart';

class RealstateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RealStateController>(
      () => RealStateController(),
    );
  }
}
