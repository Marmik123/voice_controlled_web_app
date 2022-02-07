import 'package:flutter/material.dart';
import 'package:voicewebapp/utils/material_prop_ext.dart';

Widget button({
  Function? onPressed,
  String? btnText,
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
      padding: const EdgeInsets.all(8).msp,
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
