import 'package:get/get.dart';

import '../modules/chatScreen/bindings/chat_screen_binding.dart';
import '../modules/chatScreen/views/chat_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/logIn/bindings/log_in_binding.dart';
import '../modules/logIn/views/log_in_view.dart';
import '../modules/log_in_user_profile/bindings/log_in_user_profile_binding.dart';
import '../modules/log_in_user_profile/views/log_in_user_profile_view.dart';
import '../modules/profile_screen.dart/bindings/profile_screen_binding.dart';
import '../modules/profile_screen.dart/views/profile_screen_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOG_IN,
      page: () => const LogInView(),
      binding: LogInBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOG_IN_USER_PROFILE,
      page: () => const LogInUserProfileView(),
      binding: LogInUserProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
  ];
}
