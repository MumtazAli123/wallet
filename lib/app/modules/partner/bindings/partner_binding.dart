import 'package:get/get.dart';

import '../controllers/partner_controller.dart';

class PartnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerController>(
      () => PartnerController(),
    );
  }
}
