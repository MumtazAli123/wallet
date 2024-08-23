import 'package:get/get.dart';

import '../controllers/job_controller.dart';

class JobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobController>(
      () => JobController(),
    );
  }
}
