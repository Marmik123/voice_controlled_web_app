import 'package:get/get.dart';
import 'package:voicewebapp/app/modules/about_us/bindings/about_us_binding.dart';
import 'package:voicewebapp/app/modules/about_us/views/about_us_view.dart';
import 'package:voicewebapp/app/modules/home/bindings/home_binding.dart';
import 'package:voicewebapp/app/modules/home/views/home_view.dart';
import 'package:voicewebapp/app/modules/login_screen/bindings/login_screen_binding.dart';
import 'package:voicewebapp/app/modules/login_screen/views/login_screen_view.dart';
import 'package:voicewebapp/app/modules/sign_up/bindings/sign_in_binding.dart';
import 'package:voicewebapp/app/modules/sign_up/views/sign_up.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_IN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SignInView(),
      binding: SignInBinding(),
    ),
  ];
}
