import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckputController> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  Widget form(){
    return Form(
      key: controller.checkoutKey,
      child: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.blueGrey.shade50,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: controller.flatNo,
              decoration: InputDecoration(
                labelText: 'Please enter flat number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a flat number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.apartMent,
              decoration: InputDecoration(
                labelText: 'Please enter value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.landmark,
              decoration: InputDecoration(
                labelText: 'Please enter address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.city,
              decoration: InputDecoration(
                labelText: 'Please enter a value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.state,
              decoration: InputDecoration(
                labelText: 'Please enter a value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controller.pincode,
              decoration: InputDecoration(
                labelText: 'Please enter a value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
  }

