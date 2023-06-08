import 'package:get/get.dart';

import '../controllers/log_in_user_profile_controller.dart';

class LogInUserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogInUserProfileController>(
      () => LogInUserProfileController(),
    );
  }
}
