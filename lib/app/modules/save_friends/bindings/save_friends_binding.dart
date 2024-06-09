import 'package:get/get.dart';

import '../controllers/save_friends_controller.dart';

class SaveFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaveFriendsController>(
      () => SaveFriendsController(),
    );
  }
}
