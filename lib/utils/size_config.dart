import 'package:get/get.dart';

class SizeConfig {
  // static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init() {
    // _mediaQueryData = MediaQuery.of(context);
    screenWidth = Get.width;
    screenHeight = Get.height;
  }
}
