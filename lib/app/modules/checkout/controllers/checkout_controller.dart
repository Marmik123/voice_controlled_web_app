import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckputController extends GetxController {
  //TODO: Implement CheckputController

  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController flatNo = TextEditingController();
  TextEditingController apartMent = TextEditingController();
  TextEditingController pincode = TextEditingController();
  final count = 0.obs;
  GlobalKey checkoutKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
