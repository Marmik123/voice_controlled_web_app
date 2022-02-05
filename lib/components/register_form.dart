import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/components/sized_box.dart';
import 'package:voicewebapp/utils/app_colors.dart';

Widget form({
  required GlobalKey formKey,
  Function? onSubmit,
  Widget? passwordVisibility,
  bool? hidePassword,
  required bool isSignUp,
  TextEditingController? emailTxtCtrl,
  TextEditingController? firstName,
  TextEditingController? lastName,
  TextEditingController? passwordCtrl,
}) {
  return Form(
    key: formKey,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "VOCAPP",
            style: TextStyle(
              color: Get.isDarkMode ? AppColors.kFBEEF4 : AppColors.k00474E,
              fontSize: 100.sp,
              fontWeight: FontWeight.w700,
            ),
            // textAlign: TextAlign.left,
          ),
          h(height: 40.h),
          isSignUp ? const SizedBox.shrink() : h(height: 150.sp),
          //First Name
          isSignUp
              ? SizedBox(
                  width: 550.w,
                  height: 330.h,
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: firstName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a password";
                      } else {
                        return null;
                      }
                    },
                    // obscureText: hidePassword!,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      // suffixIcon: passwordVisibility,
                      /*hintText: "Enter your password",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w400,
                                      ),*/

                      labelText: 'Enter first name',
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
                )
              : const SizedBox.shrink(),
          //Last Name
          isSignUp
              ? SizedBox(
                  width: 550.w,
                  height: 330.h,
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: lastName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a password";
                      } else {
                        return null;
                      }
                    },
                    // obscureText: hidePassword!,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      // suffixIcon: passwordVisibility,
                      /*hintText: "Enter your password",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w400,
                                      ),*/

                      labelText: 'Enter last name',
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
                )
              : const SizedBox.shrink(),
          //Email
          SizedBox(
            width: 550.w,
            height: 330.h,
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
          // h(height: 20),
          //Password
          SizedBox(
            width: 550.w,
            height: 330.h,
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
