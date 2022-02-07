import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget appBarComponent({
  Widget? iconButton,
  String? belowText,
  Function? onPressed,
}) {
  return Container(
    margin: const EdgeInsets.only(right: 20),
    child: Column(
      children: [
        iconButton ??
            IconButton(
              icon: const Icon(Icons.ac_unit_outlined),
              iconSize: 30.r,
              onPressed: () {
                onPressed;
              },
              tooltip: "No Icon added",
            ),
        Text(
          belowText ?? '-',
          style: TextStyle(
            fontSize: 45.sp,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
