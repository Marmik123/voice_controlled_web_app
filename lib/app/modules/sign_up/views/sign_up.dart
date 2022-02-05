import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/routes/app_pages.dart';
import 'package:voicewebapp/components/circular_loader.dart';
import 'package:voicewebapp/components/register_form.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/r.g.dart';
import 'package:voicewebapp/utils/app_colors.dart';
import 'package:voicewebapp/utils/material_prop_ext.dart';
import 'package:voicewebapp/utils/size_config.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetResponsiveView<SignInController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? AppColors.k444444 : AppColors.kEF9104,
            //gradient: LinearGradient(colors: [Colors.teal, Colors.cyan]),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 3,
                color: Colors.black12,
                offset: Offset(3, 2),
              )
            ],
            // borderRadius: BorderRadius.circular(30),
            shape: BoxShape.rectangle,
          ),
          height: SizeConfig.screenHeight / 0.5,
          width: SizeConfig.screenWidth / 2,
          margin: const EdgeInsets.all(80),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.asset(
                  R.image.asset.voice_c.assetName,
                  width: SizeConfig.screenWidth / 8,
                  height: SizeConfig.screenHeight / 0.5,
                  fit: BoxFit.fitHeight,
                ),
              ),
/*              FittedBox(
                fit: BoxFit.contain,
                child: IconButton(
                  padding: EdgeInsets.only(top: 350.sp),
                  alignment: Alignment.center,
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    controller.newRegisteration(false);
                  },
                ),
              ),*/
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50.w, 50.h, 50.w, 20.h),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //LOGIN OR REGISTER FORM COMPONENT.
                        //HERE ObX is a  Getx widget for state management.
                        Obx(() => form(
                              formKey: controller.formKey,
                              isSignUp: true,
                              emailTxtCtrl: controller.email,
                              passwordCtrl: controller.password,
                              firstName: controller.firstName,
                              lastName: controller.lastName,
                              passwordVisibility: Obx(() => GestureDetector(
                                    onTap: () {
                                      controller.hidePassword(
                                          !controller.hidePassword());
                                    },
                                    child: controller.hidePassword()
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: Colors.black,
                                          )
                                        : const Icon(
                                            Icons.remove_red_eye_sharp,
                                            color: Colors.black,
                                          ),
                                  )),
                              hidePassword: controller.hidePassword(),
                            )),
                        Obx(
                          () => controller.isLoading()
                              ? buildLoader()
                              : ElevatedButton(
                                  child: const Text('Register'),
                                  style: ButtonStyle(
                                      minimumSize: Size(
                                        SizeConfig.screenWidth / 15,
                                        SizeConfig.screenHeight / 18,
                                      )
                                          .msp, //where msp = MATERIAL STATE PROPERTY EXTENSION.
                                      backgroundColor: AppColors.k00474E
                                          .msp, //msp = Material State Property Extension
                                      foregroundColor: Colors.white.msp,
                                      elevation: 10.0.msp,
                                      padding: EdgeInsets.zero.msp,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ).msp //MATERIAL STATE PROPERTY EXTENSION,
                                      ),
                                  onPressed: () {
                                    ///Comment this for testing.
                                    // Get.toNamed(Routes.HOME);

                                    ///Uncomment this at last stage of project.
                                    if (controller.formKey.currentState!
                                        .validate()) {
                                      /*controller.newRegisteration()
                                        ?*/

                                      controller.registerWithEmailPassword(
                                        controller.email.text.trim(),
                                        controller.password.text.trim(),
                                      );
                                    }
                                  },
                                ),
                        ),
                        h(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Expanded(
                              child: Divider(
                                color: AppColors.kC4C4C4,
                                indent: 12,
                                thickness: 1.5,
                                endIndent: 15,
                                // endIndent: 2,
                              ),
                            ),
                            Text('OR'),
                            Expanded(
                              child: Divider(
                                color: AppColors.kC4C4C4,
                                indent: 12,
                                thickness: 1.5,
                                endIndent: 15,
                                // endIndent: 2,
                              ),
                            ),
                          ],
                        ),
                        h(height: 15),
                        TextButton(
                          onPressed: () {
                            controller.newRegisteration(true);
                            Get.toNamed(Routes.LOGIN_SCREEN);
                            /*Get.snackbar(
                              'Register with email and password',
                              'Please enter details',
                              backgroundColor: AppColors.kFFE7E7,
                              maxWidth: Get.width / 2,
                              margin: const EdgeInsets.all(10),
                              snackPosition: SnackPosition.TOP,
                            );*/
                          },
                          child: const Text(
                            'Already Registered? Sign In',
                            style: TextStyle(
                              color: AppColors.k00474E,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        h(height: 20),
                        /* GestureDetector(
                              onTap: () {
                                loginCtrl.forgotPassword.value = true;
                              },
                              child: Text(
                                "Forgot Password ?",
                                style: kInterText.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            )*/
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
