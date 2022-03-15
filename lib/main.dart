import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/utils/size_config.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAFOBgNmMW3v2Tak6cqKExkCjtJ94TBYhc",
      authDomain: "voice-controlled-app-e719f.firebaseapp.com",
      projectId: "voice-controlled-app-e719f",
      storageBucket: "voice-controlled-app-e719f.appspot.com",
      messagingSenderId: "682301866475",
      appId: "1:682301866475:web:67bc616b3e2d336fd299ae",
      measurementId: "G-W1XHBN4KTC",
    ),
  );

  //Getting Viewport dimensions. (Assigning device height and width).
  SizeConfig.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1748, 2840),
        builder: () {
          // ScreenUtil.setContext(context);
          return GetMaterialApp(
            title: "Voice Control",
            debugShowCheckedModeBanner: false,
            initialRoute: /*SharedPreference().getUserLoginStatus()
                ? Routes.HOME
                :*/
                Routes.SIGN_IN,
            getPages: AppPages.routes,
            /*theme: ThemeData().copyWith(
              primaryColor: Colors.green,
            ),*/
          );
        });
  }
}
