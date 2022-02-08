import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voicewebapp/utils/material_prop_ext.dart';

Widget button({
  Function? onPressed,
  String? btnText,
  double? btnWidth,
  double? cartAmount,
}) {
  return ElevatedButton(
    onPressed: () {
      /*setState(() {
        cardStatus = true;
      });*/
      // hCtrl.addToCartButton(true);
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
