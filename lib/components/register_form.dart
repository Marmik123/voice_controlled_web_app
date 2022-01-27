import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/utils/app_colors.dart';
import 'package:voicewebapp/utils/size_config.dart';

Widget form({
  required GlobalKey formKey,
  Function? onSubmit,
  Widget? passwordVisibility,
  bool? hidePassword,
  TextEditingController? emailTxtCtrl,
  TextEditingController? passwordCtrl,
}) {
  return Form(
    key: formKey,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "VOICE CONTROLLED WEB APP",
            style: TextStyle(
              color: Get.isDarkMode ? AppColors.kFBEEF4 : AppColors.k00474E,
              fontSize: SizeConfig.blockSizeHorizontal > 00 ? 16 : 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          h(height: 30),
          SizedBox(
            width: SizeConfig.screenWidth / 5,
            height: SizeConfig.screenHeight / 12,
            child: TextFormField(
              cursorColor: Colors.black,
              controller: emailTxtCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your email id";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: "Enter your email id",
                labelStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          h(height: 20),
          SizedBox(
            width: SizeConfig.screenWidth / 3,
            height: SizeConfig.screenHeight / 12,
            child: TextFormField(
              cursorColor: Colors.black,
              controller: passwordCtrl,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a password";
                } else {
                  return null;
                }
              },
              obscureText: hidePassword!,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                suffixIcon: passwordVisibility,
                /*hintText: "Enter your password",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w400,
                                      ),*/

                labelText: 'Enter your password',
                labelStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          h(height: 20),
        ],
      ),
    ),
  );
}
