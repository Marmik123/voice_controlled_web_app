import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildLoader() {
  return Container(
    height: 25,
    alignment: Alignment.topLeft,
    width: 20,
    child: CircularProgressIndicator(
      strokeWidth: 1,
      valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(Get.context!).primaryColorDark),
    ),
  );
}
