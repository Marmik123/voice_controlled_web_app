import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voicewebapp/app/modules/cart/controllers/cart_controller.dart';
import 'package:voicewebapp/app/modules/checkout/views/checkout_view.dart';
import 'package:voicewebapp/utils/material_prop_ext.dart';

Widget button({
  // Function? onPressed,
  String? btnText,
  required CartController controller,
  double? btnWidth,
  double? cartAmount,
}) {
  return ElevatedButton(
    onPressed: () {
      controller.getCartDetails();
      Get.defaultDialog(
        title: 'Checkout Details',
        content: const Checkout(),
      );
    },
    style: ButtonStyle(
      elevation: 10.0.msp,
      minimumSize: Size(450.w, 80.h).msp,
      padding: const EdgeInsets.all(12).msp,
    ),
    child: FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(btnText ?? 'None'),
          /*IconButton(
            alignment: Alignment.center,
            icon: Icon(
              Icons.add_circle,
              size: 35.w,
              color: Colors.white,
            ),
            onPressed: () {
              //quantity++
            },
          ),*/
        ],
      ),
    ),
  );
}
