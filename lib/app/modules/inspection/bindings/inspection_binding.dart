import 'package:get/get.dart';

import '../controllers/inspection_controller.dart';

class InspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionController>(
      () => InspectionController(),
    );
  }
}
